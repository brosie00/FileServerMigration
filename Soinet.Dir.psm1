Get-ChildItem $psscriptroot\*.ps1 | ForEach-Object -Process { . $_.FullName }

Update-TypeData -TypeName 'System.IO.DirectoryInfo' -MemberType ScriptProperty -MemberName 'isMetaDataFile' -Value { if ( ( Get-item $this ).GetFiles() -match 'DirectoryMetaDataFile.txt' ) {$True} else {$false} }

