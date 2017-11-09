Function Get-FsmFileSystemAccess {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Security.AccessControl.FileSystemAccessRule]
        $AccessRule
    )

    BEGIN {}
    PROCESS {
        foreach ( $FileSystemAccessRule in $AccessRule ) {
            $Props = @{}
            $Props.Account = $FileSystemAccessRule.IdentityReference
            $Props.IsInherited = $FileSystemAccessRule.IsInherited
            $Props.InheritanceFlags = $FileSystemAccessRule.InheritanceFlags
            Write-Debug -Message $FileSystemAccessRule.FileSystemRights
            Switch -Wildcard ($FileSystemAccessRule.FileSystemRights) {
                "FullControl" {
                    $Props.FullControl = 'True'
                    $Props.Modify = 'True'
                    $Props.ReadAndExecute = 'True'
                }
                "Modify*" {
                    $Props.FullControl = 'False'
                    $Props.Modify = 'True'
                    $Props.ReadAndExecute = 'True'
                }
                "ReadandExecute*" {
                    $Props.FullControl = 'False'
                    $Props.Modify = 'True'
                    $Props.ReadAndExecute = 'True'
                }
            }
            $Obj = New-Object -TypeName PsObject -Property $Props
            Write-Output $Obj
        }
    }   
    END { }
}
