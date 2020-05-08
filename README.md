# Get-ChromeExtensionsPerUser
Loops through all of the users in c:\users\ and looks at all of the chrome extensions folder and pulls out the extension name ane extension ID. 
  
  Exports results to a timestamped file in c:\temp\ and prints on the console.
  
  You may need to run ```Set-executionpolicy bypass -force``` before executing this script on a user system.
  
  You can follow it up with ```Set-executionpolicy default -force``` to set it back to default.
