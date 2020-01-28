$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
# . "$here\$sut"


<#
    コマンドレット Get-Location を引数なしで呼び出せばカレントフォルダが取得できる
    自動変数 $MyInvokation を見ればこのスクリプトのパスがわかる。すなわち
        $MyInvoation.MyCommand.Name がスクリプトファイル名
        $MyInvoation.MyCommand.Path がスクリプトのフルパス
    自動変数 $PSScriptRoot にはこのスクリプトの親フォルダのフルパスが格納されている
    dot sourceすることでスクリプトを読み込むことができる。
#>
$currentDir = Get-Location

Describe "組み込みコマンドレット Get-ChildItem を試す" {
    It "fixtureフォルダの下に*.lnkファイルが2つ存在する" {
        (Get-ChildItem -Path $currentDir\src\test\fixture\* -Recurse -Include *.lnk | Measure-Object).Count | Should Be 2
    }
}
