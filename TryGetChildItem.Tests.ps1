$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "TryGetChildItem" {
    It "カレントディレクトリ/fixtureフォルダの下に*.lnkファイルが2つ存在する" {
        $currentDir = Get-Location
        (Get-ChildItem -Path $currentDir\fixture\* -Recurse -Include *.lnk | Measure-Object).Count | Should Be 2
    }

    It "ショートカットのリンク先を参照してコンソールにprintする"　{
        
    }
}
