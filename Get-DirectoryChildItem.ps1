 
function Get-DirectoryChildItem {
      
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [string]
        $Path
    ) 
            
    $Array = Get-ChildItem -Path $Path 
    #if the recurse function is used above, this will take all day. 
            
    foreach ($Sub in $Array) {
        $props = @{
            'LastWriteDate' = $($sub.LastWriteTime).ToShortDateString()
            'CreationDate'  = $($sub.CreationTime).ToShortDateString()
            'Name'          = $sub.Name
            'Type'          = $(if ($sub.PSIsContainer) {'Directory'} else {'File'} )
        }

        $Obj = New-Object -TypeName PsObject -Property $props
        $Obj.psobject.TypeNames.Insert(0, "DirectoryMetaData.ChildItem")
        Write-Output $Obj  
    }
}
 
 
