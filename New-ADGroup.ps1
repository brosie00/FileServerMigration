

function New-ADGroup {
 [cmdletbinding()]
    Param(
        $Group = ( 'DeletethisGroup_' + (Get-Random -Minimum 2 -Maximum 9999 ) )
        ,
        $Description
    )
    
    Begin {
        ## add the assembly
        Try { 
            Add-Type -AssemblyName System.DirectoryServices.AccountManagement  
        }
        Catch {
            Throw "Could not load $type`: Confirm .NET 3.5 or Later is installed"
            Break
        }
        ## create the context i.e. connect to the domain
        $ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain 
        $context = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext -ArgumentList $ct, "ds.irsnet.gov", "OU=LAN Accounts,OU=Users and Groups,DC=soinet,DC=soi,DC=irs,DC=gov"  
    
    }
    Process {
        ## set group type
        $gtype = [System.DirectoryServices.AccountManagement.GroupScope]::Global  

        $grp = New-Object -TypeName System.DirectoryServices.AccountManagement.GroupPrincipal -ArgumentList $context, $Group
        $grp.IsSecurityGroup = $true
        $grp.GroupScope = $gtype
        $grp.Save() 
    }
}


