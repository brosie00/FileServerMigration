 <#

Do not use
        .Synopsis
        Collect MetaData about a Directory
        .DESCRIPTION
        We collect Datea from a DirectoryMetaDataFile.txt if one exists.
        We inventory the existing facts about the Directory
        - Creation Date
        - Last Write Time
        - Date this inventory was conducted 
    
        We list subdirectories and their creation date that are found within this directory
        We list files and their creation dates that are found within this directory
    
        We list the existing NTFS Access permissions

        We list the members of the group with Modify Access to this directory.

        .EXAMPLE
        Example of how to use this cmdlet
        .EXAMPLE
        Another example of how to use this cmdlet
#>
function New-DirectoryMetaData {
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        $Path
    )
    Begin {
    }
    Process {
        foreach ( $PathItem in $Path ) {
            Write-Verbose -Message "Gathering Data for Directory $PathItem"
            Try {
                $MetaDataHeader = Import-DirectoryMetadataFile -Path $PathItem 
            }
            catch { 'File Not Found'
            New-MetaDataHeader }
            
            $Items = Get-DirectoryChildItem -Path $PathItem

            $Access = Show-ACL -Path $PathItem | Select-Object Account, FullControl, Modify, ReadAndExecute, IsInherited

        }
    }
    End {
    }
}

#([System.IO.Directory]::GetDirectories("C:\Users\swwcb\desktop", "*", 'AllDirectories')).Count 
