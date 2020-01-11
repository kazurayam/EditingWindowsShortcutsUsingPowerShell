filter Convert-LocalPath {
    param (
        [parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )]
        [string] $Path,

        [ValidateNotNullOrEmpty()]
        [uri] $Location = (Get-Location).Path,

        [switch] $Relative
    )

    if (-not $Relative) {
        return [uri]::new($Location, $Path).LocalPath
    }

    $localPath = $Location.MakeRelative($Path) -replace '/', '\'
    if ($localPath.StartsWith('.')) {
        $localPath
    } else {
        ".\${localPath}"
    }
}
