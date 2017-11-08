# Get-ChildItem $psscriptroot\*.ps1 | ForEach-Object -Process { . $_.FullName }

. $psscriptroot\FsmShow-ACL.ps1
. $psscriptroot\Get-FsmDirectoryMetaData.ps1
. $psscriptroot\Import-FsmMetaDataHeader.ps1
. $psscriptroot\New-FsmMetaDataHeader.ps1

Update-TypeData -TypeName 'System.IO.DirectoryInfo' -MemberType ScriptProperty -MemberName 'isMetaDataFile' -Value { if ( ( Get-item $this ).GetFiles() -match 'DirectoryMetaDataFile.txt' ) {$True} else {$false} }

 

