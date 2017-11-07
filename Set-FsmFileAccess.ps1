 

<#
.Synopsis
   Uses CACLS rather then the Set-Acl
.DESCRIPTION
   Working with the .NET base libraries is miserable.  I would rather use CACLS.
.EXAMPLE
   Set-FileAccess -Path "c:\ref" -Access "Change" -Group "soinet\brosieadm"
.EXAMPLE
   Another example of how to use this cmdlet
.NOTES
   https://technet.microsoft.com/en-us/library/bb490872.aspx

   cacls.exe /?

#>

Function Set-FsmFileAccess {

    param ( 
        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true, 
            ValueFromRemainingArguments = $false)]
        [ValidateScript( {Test-Path -Path $_ })]
        $Path
        ,

        [ValidateSet("Change", "ReadOnly", "FullControl")]
        $Access
        ,
        
        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true, 
            ValueFromRemainingArguments = $false)]
        [ValidatePattern( "ds\\" )]
        $SecurityGroup
    )

    $AccessRight = switch ($Access) {
        'Change'      {"C"}
        'ReadOnly'    {"R"}
        'FullControl' {"F"}
    }
    <#

        /t   : Changes DACLs of specified files in the current directory and all subdirectories. 
        /c   : Continues to change DACLs, ignoring errors. 
        /g   User  : permission    : Grants access rights to the specified user.      
        /p   User  : permission    : Replaces access rights for the specified user. 

    #>
    CACLS.exe $file /T /E /P  "${SecurityGroup}:${AccessRight}" 

} 
