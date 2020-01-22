[CmdletBinding()]

 

#Parameters

 

$subscriptionId = 'cc75dc89-775a-4bc0-a439-a9412fd9ac9c'
$LabResourceGroup = 'SEA-PUN-Dev-2'
$LabName = 'SEA-PUN-Dev-2'
$NewVmName = 'DTLAutoCI12'
$user = "sheetal.sakore@bentley.com"
$pass = "Matrix2009!@"
$secpass = ConvertTo-SecureString -String $pass -AsPlainText -Force

 

$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($user, $secpass)
Connect-AzAccount -Credential $Cred

 

 

Select-AzSubscription -SubscriptionId $subscriptionId
 
pushd $PSScriptRoot

 

try {
    if ($SubscriptionId -eq $null) {
        $SubscriptionId = (Get-AzContext).Subscription.SubscriptionId
    }

 

    $API_VERSION = '2016-05-15'
    $lab = Get-AzResource -ResourceId "/subscriptions/$SubscriptionId/resourceGroups/$LabResourceGroup/providers/Microsoft.DevTestLab/labs/$LabName"

 

    if ($lab -eq $null) {
       throw "Unable to find lab $LabName resource group $LabResourceGroup in subscription $SubscriptionId."
    }

 

    #For this example, we are getting the first allowed subnet in the first virtual network
    #  for the lab.
    #If a specific virtual network is needed use | to find it. 
    #ie $virtualNetwork = @(Get-AzResource -ResourceType  'Microsoft.DevTestLab/labs/virtualnetworks' -ResourceName $LabName -ResourceGroupName $lab.ResourceGroupName -ApiVersion $API_VERSION) | Where-Object Name -EQ "SpecificVNetName"

 

    $virtualNetwork = @(Get-AzResource -ResourceType  'Microsoft.DevTestLab/labs/virtualnetworks' -ResourceName $LabName -ResourceGroupName $lab.ResourceGroupName -ApiVersion $API_VERSION)[0]

 

    $labSubnetName = $virtualNetwork.properties.allowedSubnets[0].labSubnetName

 

    #Prepare all the properties needed for the createEnvironment
    # call used to create the new VM.
    # The properties will be slightly different depending on the base of the vm
    # (a marketplace image, custom image or formula).
    # The setup of the virtual network to be used may also affect the properties.
    # This sample includes the properties to add an additional disk under dataDiskParameters
    
    $parameters = @{
       "name"      = $NewVmName;
       "location"  = $lab.Location;
       "properties" = @{
          "labVirtualNetworkId"     = $virtualNetwork.ResourceId;
          "labSubnetName"           = $labSubnetName;
          "notes"                   = Win10x64Autom1SysprepCI";
           "customImageId" = "/subscriptions/cc75dc89-775a-4bc0-a439-a9412fd9ac9c/resourcegroups/sea-pun-dev-2/providers/microsoft.devtestlab/labs/sea-pun-dev-2/customimages/win10x64autom1sysprepci";
          "osType"                  = "windows"
          "expirationDate"          = "2020-12-01"
          
         # "galleryImageReference"   = @{
            # "offer"     = "Windows-10";
            #"publisher" = "MicrosoftWindowsDesktop";
           #  "sku"       = "19h1-ent";
             #"osType"    = "Windows";
            # "customImageId" = "/subscriptions/cc75dc89-775a-4bc0-a439-a9412fd9ac9c/resourceGroups/sea-pun-dev-2/providers/microsoft.compute/images/win10x64autom1sysprepci";
             #"version"   = "latest"
            
         # };
          "size"                    = "Standard_B2ms";
          "userName"                = "Common";
          "password"                = "Master_mind";
          "disallowPublicIpAddress" = $true;
                                    
       }
    }
    
    #The following line is the same as invoking
    # https://azure.github.io/projects/apis/#!/Labs/Labs_CreateEnvironment rest api

 

    Invoke-AzResourceAction -ResourceId $lab.ResourceId -Action 'createEnvironment' -Parameters $parameters -ApiVersion $API_VERSION -Force -Verbose
}
finally {
   popd
}
