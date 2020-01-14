# カレントディレクトリ
$current = (Get-Location).Path
#Write-Host ">>> current is ${current}"

# このテストスクリプトのファイル名
$thisFileName = $MyInvocation.MyCommand.Name
#Write-Host ">>> thisFileName is ${thisFIleName}"

#　"sut" とは Script-Under-Test つまりテストの対象であるスクリプトのこと
$sutFileName = $thisFileName -replace "Test\.ps1", ".ps1"
#Write-Host ">>> sutFileName is ${sutFileName}"

#  sutをdot sourceする、つまり読み込む
. (Join-Path ${current} "src\main\powershell\${sutFileName}")

$fixture = (Join-Path ${current} "src\test\fixture")
Write-Host ">>> fixture is ${fixture}"

Describe "Convert-AbsolutePathToRelative" {
    It "絶対パスを　或る基底からの相対パスに変換する" {        
        $base = $fixture
        Write-Host ">>> base is ${base}"
        $abs = Join-Path $fixture "subfolder\moreLinkToAppData.lnk"
        Write-Host ">>> abs is ${abs}"
        (Convert-AbsolutePathToRelative -Path $abs -Base $base -Relative
        ) | Should Be '.\subfolder\moreLinkToAppData.lnk'
    }
}
