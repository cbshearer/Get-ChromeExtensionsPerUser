## Adapted from https://community.spiceworks.com/scripts/show/3911-get-chromeextensions-ps1
## param([String]$OutputFolder=$null,[String]$ExtensionId=$null,[Switch]$Remove, [Switch]$WhatIf)

## Globals
$date = Get-Date
$comp = $env:computername
$n = 0

$auditfilepathCSV = "c:\temp\Chrome_ExtensionsCSV-$(get-date -f yyyy-MM-dd_h-m-ss_tt).CSV"

## write hostname to log screen
write-host "$env:computername $env:USERNAME $date"  

## The extensions folder is in local appdata ## loop through every user folder in c:\users
$userfolders = get-childitem "c:\users"

## Loop through each user folder
foreach ($folder in $userfolders)
    {
        ## Display the user foldername
        write-host -f green $folder
        $extension_folders = Get-ChildItem -Path "c:\users\$folder\appdata\local\Google\Chrome\User Data\Default\Extensions" -ErrorAction SilentlyContinue

    ## Loop through each extension folder
    foreach ($extension_folder in $extension_folders ) 
        {
            ## Get the version specific folder within this extension folder
            $version_folders = Get-ChildItem -Path "$($extension_folder.FullName)"

            ## Loop through the version folders found
            foreach ($version_folder in $version_folders) {
                ## The extension folder name is the app id in the Chrome web store and null out the name variable
                $appid = $extension_folder.BaseName
                $name = $null
                
                ## If the path exists, try to get the name from the JSON file
                if(Test-Path -Path "$($version_folder.FullName)\manifest.json") {
                    try {
                        $json = Get-Content -Raw -Path "$($version_folder.FullName)\manifest.json" | ConvertFrom-Json
                        $name = $json.name
                    } catch {
                        $name = ""
                    }
                }

                ## If we find _MSG_ in the manifest it's probably an app
                if( $name -like "*MSG*" ) {
                    ## Sometimes the folder is 'en'
                    if( Test-Path -Path "$($version_folder.FullName)\_locales\en\messages.json" ) {
                        try { 
                            $json = Get-Content -Raw -Path "$($version_folder.FullName)\_locales\en\messages.json" | ConvertFrom-Json
                            $name = $json.appName.message
                            ## Try a lot of different ways to get the name
                            if(!$name) {
                                $name = $json.extName.message
                            }
                            if(!$name) {
                                $name = $json.extensionName.message
                            }
                            if(!$name) {
                                $name = $json.app_name.message
                            }
                            if(!$name) {
                                $name = $json.application_title.message
                            }
                        } catch { 
                            #$_
                            $name = ""
                        }
                    }
                    ## Sometimes the folder is en_US
                    if( Test-Path -Path "$($version_folder.FullName)\_locales\en_US\messages.json" ) {
                        try {
                            $json = Get-Content -Raw -Path "$($version_folder.FullName)\_locales\en_US\messages.json" | ConvertFrom-Json
                            $name = $json.appName.message
                            ## Try a lot of different ways to get the name
                            if(!$name) {
                                $name = $json.extName.message
                            }
                            if(!$name) {
                                $name = $json.extensionName.message
                            }
                            if(!$name) {
                                $name = $json.app_name.message
                            }
                            if(!$name) {
                                $name = $json.application_title.message
                            }
                        } catch {
                            #$_
                            $name = ""
                        }
                    }
            }

        ## If we can't get a name from the extension use the app id instead
        if( !$name ) {
            $name = "[$($appid)]"
        }
        
        ## App id given on command line and this did NOT match it
        if( $ExtensionId -and ($appid -ne $ExtensionId) ) { 
            write-host "Skipping: [$appid] output"
        ## App id not given on command line
        } else {
            ## Increment counter                
            $n = $n + 1
            ## Dump to audit file
            write-host "Extension: $appid - " -nonewline; write-host -f Green "$folder"-nonewline; write-host " - $name ($($version_folder))."
            if(!($WhatIf)) {
                
                $object = New-Object -typename psobject
                $object | Add-Member -MemberType NoteProperty -Name Name       -Value $name
                $object | Add-Member -MemberType NoteProperty -Name Version    -Value $version_folder
                $object | Add-Member -MemberType NoteProperty -Name AppID      -Value $appid
                $object | Add-Member -MemberType NoteProperty -Name UserFolder -Value $folder
                $object | Add-Member -MemberType NoteProperty -Name Date       -Value $date
                $object | Add-Member -MemberType NoteProperty -Name Computer   -Value $comp
                
                $object | export-csv $auditfilepathCSV -append -NoTypeInformation
            }
        }
    }
}
}
write-host "================$n"

Write-Host -f Cyan $auditfilepathCSV
