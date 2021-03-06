

<#        
.Synopsis        
Parses the Access Control List (ACL) and displays same.        
.DESCRIPTION        
This cmdlet is meant to present the ACL during written reports.        
.EXAMPLE        
Show-ACL -Path $pwd         
Automatically Formatted as a list         
Account          : BUILTIN\Administrators        
FullControl      : True        
Modify           : True        
ReadAndExecute   : True        
IsInherited      : True        
InheritanceFlags : ContainerInherit, ObjectInherit        
Path             : C:\Oracle\product\12.1.0\client_1\Network\Admin       
IsContainer      : True        
.EXAMPLE        The Output can be formatted with Format-Table. However, it should first be sorted so that the property is properly seperated.        
Show-ACL -Path $pwd | select Path, Account, IsContainer, FullControl, Modify, ReadAndExecute, IsInherited, InheritanceFlags | Sort-Object -Property Modify | ft -GroupBy Modify #>
function New-FsmAccessDescription {
    [CmdletBinding()]    
    Param    (        [Parameter(ValueFromPipelineByPropertyName = $true)]    
        [Alias('Filename', 'File', 'FullName', 'PsPath', 'Name', 'Directory')]        
        [string[]]       
        $Path = 'C:\Users\SWWCB\Documents'    )      
    Begin {     }      
    Process {         
        foreach ( $PathString in $Path ) {  
            $PathString = Resolve-Path -Path $PathString    
            $AccessRule = Get-Acl -Path $PathString |                
                Select-Object -ExpandProperty Access |                
                Get-FsmFileSystemAccess                    
            Foreach ($Rule in $AccessRule) {                
                $Props = @{}                
                $Props.Path = $PathString                
                $Props.Account = $Rule.Account               
                $Props.ReadAndExecute = $Rule.ReadAndExecute               
                $Props.FullControl = $Rule.FullControl                
                $Props.IsInherited = $Rule.IsInherited              
                $Props.InheritanceFlags = $Rule.InheritanceFlags               
                $Props.Modify = $Rule.Modify                                


                $Description = New-Object -TypeName PSObject -Property $Props                
                Write-Output  -InputObject $Description            
            }        
        }    
    }   
    End { } #end End
} #end function 



