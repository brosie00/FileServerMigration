Function New-FsmMetaDataHeader {
    param (
        [Parameter( ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [Alias('Directory')]
        $Path = $PWD.PATH
    )

    $Directory = Get-Item -Path $Path  
    $Props = @{}
    switch ($env:USERDOMAIN) {
        SOINET {
            $Props.SOIDPS_Path = 'SOIDPS_Path', $Directory.FullName -join '::'
            $Props.SOINET_Path = $Null
            $Props.Test_Domain = $Null
        }
        SOIDPS {
            $Props.SOIDPS_Path = $Null
            $Props.SOINET_Path = 'SOINET_Path', $Directory.FullName -join '::'
            $Props.Test_Domain = $Null
        }
        default {
            $Props.SOIDPS_Path = $Null
            $Props.SOINET_Path = $Null
            $Props.Test_Domain = $env:USERDOMAIN, $Directory.FullName -join '::'
        }
    }

    $Props.DirectoryID = [Guid]::NewGuid()
    $Props.LastModified = $Directory.LastWriteTime 
    $Props.Created = $Directory.CreationTime
    $Props.ReportRun = (Get-Date)

    $Obj = New-Object -TypeName PsObject -Property $Props
    $obj.psobject.TypeNames.Insert(0, 'DirectoryData.MetaDataHeader')  
    Write-Output $Obj
}

