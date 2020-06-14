# Get-ChromeExtensionsPerUser
- Loops through all of the users in ```c:\users\``` and looks at all of the chrome extensions folders and pulls out the extension name and extension ID.  
- Exports results to a timestamped file in ```c:\temp\```

## Output:
- Computer name, user running the script and timestamp are displayed
- Computer users are listed one by one, even if they don't have any extensions installed along with the path to their extensions
- For each user there is one line per extension showing: 
  - Extension ID
  - Name of the extension if one can be found
- Path to file where information was also saved in ```c:\temp\```
  
## Note: 
- You may need to run ```Set-executionpolicy bypass -force``` before executing this script on a user system.  
- You can follow it up with ```Set-executionpolicy default -force``` to set it back to default.  
