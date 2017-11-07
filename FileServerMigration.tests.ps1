. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')
Describe 'Import-MetaDataHeader' {    
    $TestPath = 'TestDrive:\DirectoryMetaDataFile.txt'    
    Add-Content -Path  $TestPath -Value 'DirectoryID   : d35622c0-667e-47e4-942d-c8cec7cea081'    
    Add-Content -Path $TestPath -Value 'Created       : 4/20/2013'    
    Add-Content -Path $TestPath -Value "ReportRun     : $(Get-Date)"    
    Add-Content -Path $TestPath -Value 'SOIDPS_Path   : M:\Groups'    
    Add-Content -Path $TestPath -Value 'SOINET_Path   : I:\Groups'    
    Add-Content -Path $TestPath -Value 'Test_Path'    
    Add-Content -Path $TestPath -Value 'MetaDataFileHashofRecord    : 7CA185EEAF69C1C049E7DED434E9F83BEB5875C5F875EBF31417643B4469283F'
    
    Context 'The Directory MetaDataFileExists' {        
        $Results = Import-MetaDataHeader -Path TestDrive: 
                
        It 'May be a SOIDPS original directory' {}        
        It 'May be a SOINET original directory' {}        
        It 'May originate outside the two domains for testing purposes' { 
            $Results.TestDomain | Should Match "$env:USERDOMAIN" }        
        It 'Has a property that will report the Directorys Last Modified Date' {$Results.Created | Should BeLessThan (Get-Date)}        It 'Has a property that will report the Directorys CreationDate' {$Results.Created | Should BeLessThan (Get-Date)}        It 'Has a property reporting the assigned DirectoryID' { $Results.DirectoryID | Should BeOfType [GUID]}        It 'Has a property reporting the most recent date the Directory inventory was run' { $Results.ReportRun | Should BeLessThan (Get-Date ) }        It 'Has a Filehash recorded in the DirectoryMetaDataFile.txt' {$Results.MetaDataFileHashofRecord | Should be '7CA185EEAF69C1C049E7DED434E9F83BEB5875C5F875EBF31417643B4469283F'} -Pending    }}
Describe 'New-MetaDataHeader' {     
    New-Item -Path 'TestDrive:' -ItemType Directory -Name Test
    $MetaDataHeader = New-MetaDataHeader -Path 'TestDrive:\Test'       
    It 'Creates a DirectoryId' { $MetaDataHeader.DirectoryID | Should BeOfType [GUID] }    
    It 'May be a SOIDPS original directory' { $MetaDataHeader.SOIDPS_Path | Should match "('SOIDPS'|$NULL)"}    
    It 'May be a SOINET original directory' { $MetaDataHeader.SOINET_Path | Should match "('SOINET'|$NULL)"}   
    It 'May originate outside the two domains for testing purposes' { $MetaDataHeader.Test_Domain | Should Match "($env:USERDOMAIN|$NULL )" }     It 'Has a property that will report the Directorys Last Modified Date' {        $MetaDataHeader.LastModified | Should BeLessThan (Get-Date).AddHours(1)          $MetaDataHeader.LastModified | Should BeOfType [DateTime]    }    It 'Has a property that will report the Directorys CreationDate' {        $MetaDataHeader.Created |    Should BeLessThan (Get-Date).AddHours(1)        $MetaDataHeader.Created |    Should BeOfType [DateTime]    }    It 'Has a property reporting the assigned DirectoryID' { $MetaDataHeader.DirectoryID | Should BeOfType [GUID]}    It 'Has a property reporting the most recent date the Directory inventory was run' {        $MetaDataHeader.ReportRun | Should BeLessThan (Get-Date )         $MetaDataHeader.ReportRun |   Should BeOfType [datetime]    }    It 'Has a Filehash recorded in the DirectoryMetaDataFile.txt' {$MetaDataHeader.MetaDataFileHashofRecord | Should be '7CA185EEAF69C1C049E7DED434E9F83BEB5875C5F875EBF31417643B4469283F'} -Pending}
#>
