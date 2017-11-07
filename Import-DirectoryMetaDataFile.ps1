<#        
.SYNOPSIS        Reads a file within each directory and creates an object for further use in the script.        
.DESCRIPTION        It 'Returns a DirectoryID property as a GUID'        
It 'Returns an SOINET_Path, if found '         
It 'Returns an SOIDPS_Path, if found '       
.PARAMETER PATH         This path should only reb        
.INPUTS        This cmdlet will accept either a directory or direct filepath to DirectoryMetaDataFile.txt        
.OUTPUTS        this cmdlet will produces a PowerShell object         
.NOTES        I would like to build a metadata text file for each subdirectory as my users move directories between domains. I need to code defensively against two scenarios: 1) the file does not exist, 2 ) the file exists but does not contain the metadata that I am expect to be there. #>
function Import-MetaDataHeader {
[cmdletbinding()]   
param(        
[Parameter(ValueFromPipeline = $true,           
ValueFromPipelineByPropertyName = $true)]        
[ValidateScript( { Test-Path $_  })]       
[Alias('Directory')]        $Path    
)   
#  $Path = Resolve-Path $Path   
$Item = Get-Item -Path $Path    #"Just in case someone supplies a the fullpath to the DirectoryMetaData    
if (  $Item.PSIsContainer ) { $DirPath = $Item.FullName } else { $DirPath = $Item.Parent } 
    
    try {        $FilePath = Join-Path -Path $DirPath -ChildPath 'DirectoryMetaDataFile.txt'        $Content = Get-Content $FilePath -ErrorAction Stop        Write-Verbose -Message "Reading from the file: $FilePath"    }    catch { Write-Verbose -Message " There is no DirectoryMetatDataFile.txt in the Directory: $DirPath"  } 
    if ($Content) {        if ((( $Content -match 'DirectoryID'              ) -split ' : ')[1] -as [GUID])
    {            
    $Properties = @{                
    SOIDPS_Path           = (( $Content -match 'SOIDPS_Path'              ) -split ' : ')[1]
    SOINET_Path           = (( $Content -match 'SOINET_Path'              ) -split ' : ')[1] 
    DirectoryID           = (( $Content -match 'DirectoryID'              ) -split ' : ')[1] -as [GUID]
    DirectoryMetaFileDate = (  Get-Item -Path $FilePath | Select-Object -ExpandProperty LastWriteTime )               
    # MetaDataFileHashofRecord = (( $Content -match 'MetaDataFileHashofRecord' ) -split ' : ')[1]            }        
    $obj = New-Object -TypeName PSObject -Property $Properties           
    $obj.psobject.TypeNames.Insert(0, 'DirectoryData.MetaDataHeader')           
    Write-Output -InputObject $obj        }        else {
    Write-Warning "$FilePath does not contain DirectoryID.  New MetaData will be created."}    } }  

