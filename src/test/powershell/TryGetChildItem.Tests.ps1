<#
    コマンドレット Get-Location を引数なしで呼び出せばカレントフォルダが取得できる
    自動変数 $MyInvokation を見ればこのスクリプトのパスがわかる。すなわち
        $MyInvoation.MyCommand.Name がスクリプトファイル名
        $MyInvoation.MyCommand.Path がスクリプトのフルパス
    自動変数 $PSScriptRoot にはこのスクリプトの親フォルダのフルパスが格納されている
    dot sourceすることでスクリプトを読み込むことができる。
#>
$current = Get-Location
$srcMainPs = "${current}\src\main\powershell"
$srcTestPs = "${current}\src\test\powershell"
// このスクリプトのフルパス
$fullPathOfThis = Split-Path -Parent $MyInvocation.MyCommand.Path
// srcTestPsを基底とした場合のこのスクリプトの相対パス
$relativePathOfThis = 

$scriptUnderTest = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$scriptUnderTest"

Describe "TryGetChildItem" {
    It "カレントディレクトリ/fixtureフォルダの下に*.lnkファイルが2つ存在する" {
        $currentDir = Get-Location
        (Get-ChildItem -Path $currentDir\fixture\* -Recurse -Include *.lnk | Measure-Object).Count | Should Be 2
    }
}
