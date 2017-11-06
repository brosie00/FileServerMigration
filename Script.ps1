 <#
.SYNOPSIS
    Run this script against a directory to create a Directory Metadata file
.DESCRIPTION
    Long description
.PARAMETER Path
    Specifies a path to one or more locations.
.PARAMETER LiteralPath
    Specifies a path to one or more locations. Unlike Path, the value of LiteralPath is used exactly as it
    is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose
    it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any
    characters as escape sequences.
#>

[CmdletBinding()]
Param
(
    [Parameter(ValueFromPipeline = $true,
    ValueFromPipelineByPropertyName = $true)]
    [ValidateScript({Test-Path $_ -type container })]
    [string]
    $Path = '\\Fileserver.soinet.soi.irs.gov\groups\techdps'
    
)

#region touch the Directory 45e0adee-487e-4dc9-a671-081cbaa82220

$PathProperties = Get-Item -Path $Path 
$FilePath = Join-Path -Path $Path -ChildPath 'DirectoryMetaData.txt'
try { $CurrentFile = Get-Content $FilePath } catch {}

#set the defaults
$CurrentFileContentsHash = @{}

$CurrentFileContentsHash.DirectoryLastModified = $PathProperties.LastWriteTime
Try { $CurrentFileContentsHash.DirectoryCreatedDate   = (( $CurrentFile -match 'DirectoryCreatedDate'  ) -split ' : ')[1]  } catch{}
Try { $CurrentFileContentsHash.SOINET_Directory      = (( $CurrentFile -match 'SOINET_Directory'      ) -split ' : ')[1] } catch{}
Try { $CurrentFileContentsHash.DirectoryID    = (( $CurrentFile -match 'DirectoryID'    ) -split ' : ')[1] } catch{}

#endregion

#region Import-DirectoryDataFile and change the defaults
#only some of that data will be changed by whatever MAY be written in the DirectoryDataFile.

if (-not ( $CurrentFileContentsHash.SOINET_Directory )) {$CurrentFileContentsHash.SOINET_Directory = $($PathProperties.FullName).tostring()}

if (-not ( $CurrentFileContentsHash.DirectoryID )) 
{
    $CurrentFileContentsHash.DirectoryID = $env:USERDOMAIN, [System.Guid]::NewGuid().ToString('d') -join'::' #no braces; convert the GUID object to a string
}

if (-not( $CurrentFileContentsHash.DirectoryCreatedDate ) ) {[datetime]$CurrentFileContentsHash.DirectoryCreatedDate = $PathProperties.CreationTime}

#endregion

　
#region Convert the Hash table to an object so that it formats correctly as text

New-Object -TypeName PsObject -Property $CurrentFileContentsHash |
Format-List |
Out-File $FilePath

#endregion 

#region List SubDirectories

'This Directory contains the following subdirectories' | Out-File -FilePath $FilePath -Append

$Array = Get-ChildItem -Path $Path |
Where-Object -FilterScript { $_.PSIsContainer -match $true } |
Select-Object -Property Fullname, LastWriteTime
$Array |
Format-Table -AutoSize |
Out-File $FilePath -Append 
#endregion

'This Directory contains the following files' | Out-File -FilePath $FilePath -Append

Get-ChildItem -Path $Path |
Where-Object -FilterScript { $_.PsIsContainer -eq $false }|
Select-Object -Property Name, CreationTime |
Out-File -FilePath $FilePath -Append

'In addition to be able to read the contents of this directory, the following members and groups may modify the contents of this directory.' | Out-File -FilePath $FilePath -Append

$Domain = $env:USERDOMAIN, '\\' -join ''
$a =  Show-Acl -path $path | 
Where-Object {$_.Account -notmatch  'Builtin'  }      | 
Where-Object {$_.Account -notmatch  'NT Authority'  } |
Where-Object {$_.Account -notmatch  'S-1-5-21'   }    |
Select-Object -Property  @{ N='Account'; E={ ($_.Account.ToString() -replace $Domain,'')}},  InheritanceFlags, IsInherited

$a | Format-Table -AutoSize  | Out-File -FilePath $FilePath -Append

foreach($Group in $a) {

    $Group.Account
 }

 
