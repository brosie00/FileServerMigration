

#Dot source all functions in all ps1 files located in the module folder
Get-ChildItem -Path $PSScriptRoot\*.ps1 -Exclude *.tests.ps1, *profile.ps1 |
    ForEach-Object {
    . $_.FullName
}

Update-TypeData -TypeName 'System.IO.DirectoryInfo' -MemberType ScriptProperty -MemberName 'isMetaDataFile' -Value { if ( ( Get-item $this ).GetFiles() -match 'DirectoryMetaDataFile.txt' ) {$True} else {$false} }

Update-TypeData -AppendPath $PSScriptRoot\FileInfo.types.ps1xml 

#$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {  Remove-TypeData -Path $PSScriptRoot\FileInfo.types.ps1xml }


 