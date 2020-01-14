<#
    Convert-AbsolutePathToRelative
    
    Pathパラメータが絶対パスであるとき、Baseパラメータを基底とする相対パスに変換する。
    
    使用例:
    > Convert-AbsolutePathToRelative -Path "X:\foo\baz.txt" -Base "X:\foo\bar\" -Relative    # => ..\baz.txt 

    See
    https://qiita.com/yumura_s/items/0aed4c275432993e9174
    
#>
filter Convert-AbsolutePathToRelative {
    param (
        [parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )]
        [string] $Path,

        [ValidateNotNullOrEmpty()]
        [uri] $Base = (Get-Location).Path,

        [switch] $Relative
    )

    if (-not $Relative) {
        return [uri]::new($Base, $Path).LocalPath
    }

    $pathURI = [uri]::new($Path)
    $localPath = $Base.MakeRelativeUri($pathURI) -replace '/', '\'
    
    Write-Host "<<< Base is ${Base}"
    Write-HOst "<<< Path is ${Path}"
    Write-HOst "<<< pathURI is ${pathURI}"
    Write-Host "<<< localPath is ${localPath}"

    if ($localPath.StartsWith('.')) {
        $localPath
    } else {
        ".\${localPath}"
    }
}
