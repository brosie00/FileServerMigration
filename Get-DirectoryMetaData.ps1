 #requires
#TODO: validate path for directory
function Get-DirectoryMetaData {
    param(
        [ValidateScript( { Test-Path $_ -PathType 'Container' })]
        [string]
        $Path
    )
    
    $DirectoryItem = Get-Item $Path
     

   $ImportedFileData = Import-DirectoryMetadataFile -Path $Path

　
    
    $Props = @{}
    if ( $ImportedFileData) {
 $Props.SOINET_Path      = $ImportedFileData.SOINET_Path  
    $Props.HashofRecord     = $ImportedFileData.HashofRecord
    $Props.SOIDPS_Path      = $ImportedFileData.SOIDPS_Path

    $Props.DirectoryID      = $ImportedFileData.DirectoryID

    } else {

　
    $Props.HashofRecord     = ( Get-FileHash -Path $DirectoryItem -Algorithm MD5)
$Props.SOIDPS_Path = ()
$Props.SOINET_Path = 
$Props.DirectoryId = 

    }
   

    $Props.Files            = $DirectoryItem.EnumerateFiles() | Select-Object -Property  Name, CreationTime, LastWriteTime
    $Props.Directories      = $DirectoryItem.EnumerateDirectories() | Select-Object -Property  Name, CreationTime, LastWriteTime
    $Props.FullName         = $DirectoryItem.Fullname
    $Props.Accesscontrol    = $DirectoryItem.GetAccessControl().Access
    $Props.CreationDate     = $DirectoryItem.CreationTime
    $Props.Domain           = $env:USERDOMAIN 
    $Props.HashActual = Get-FileHash -Path ( Join-Path -path $Path -ChildPath DirectoryMetaDatafile.txt ) | Select-Object -ExpandProperty Hash
    
    $Object = New-Object -TypeName PSObject -Property $Props
    $Object.psobject.TypeNames.Insert(0, 'DirectoryData')
    Write-Output -InputObject $Object
} 
