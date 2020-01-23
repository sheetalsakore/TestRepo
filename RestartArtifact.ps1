{ 
2   "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json", 
3   "title": "Restart", 
4   "publisher": "Microsoft", 
5   "description": "Restarts the virtual machine.", 
6   "tags": [ 
7     "Windows" 
8   ], 
9   "targetOsType": "Windows", 
10   "runCommand": { 
11     "commandToExecute": "cmd /c echo Restarting this virtual machine." 
12   }, 
13   "postDeployActions": [ 
14     { 
15       "action": "restart" 
16     } 
17   ] 
18 } 
