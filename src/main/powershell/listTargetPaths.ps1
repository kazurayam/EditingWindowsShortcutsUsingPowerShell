$currentDir = Get-Location
$module = (Join-Path $currentDir 'src\main\powershell\GetShortcutTargetPath.psm1')
Import-Module $module -function *

$targetProjectDir = 'C:\HomePageServices'

<#
    look for Windows Shortcuts under the given directory,
    retrieve targetPath value of them,
    and show the sorted list of targetPaths with counts
#>


$hash = @{}
Get-ChildItem $targetProjectDir -Recurse -Filter *.lnk | ForEach-Object {
    $targetPath = Get-ShortcutTargetPath -Shortcut $_.FullName
    # Write-Host $targetPath
    if  (!$hash.ContainsKey($targetPath)) {
        $hash.Add($targetPath, 1)
    } else {
        $count = $hash[$targetPath]
        $hash[$targetPath] = $count + 1
    }
}

$hash.keys | Sort-Object | ForEach-Object {
    Write-Host "$_ $($hash[$_])"
}
