$currentDir = Get-Location
$module = (Join-Path $currentDir 'src\main\powershell\ConvertShortcutTargetPath.psm1')
Import-Module $module -function *

$targetProjectDir = 'C:\GheReposX'

<#
    targetProjectDirの下にあるすべてのショートカットを調べる。
    各ショートカットのリンク先を読み出し、リンク先が 
        C:\SvnReposX
    で始まっていたら、その箇所を
        C:\GheReposX
    に書きかえる。
    まずは -Dryrun を指定して妥当な動きをするかどうかを確認しよう。
#>

$countAll = 0
$countFailures = 0
Get-ChildItem $targetProjectDir -Recurse -Filter *.lnk | ForEach-Object {
    $countAll += 1
    $result = Convert-ShortcutTargetPath -Shortcut $_.FullName -Regexp '^C:\\SvnReposX' -Replacement 'C:\GheReposX' -Dryrun
    if (!$result) {
        $countFailures += 1
        Write-Host ""
    }
}

Write-Host "Total: ${countAll}, Passed: $($countAll - $countFailures), Failed: ${countFailures}"

