$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1', '.psm1'
Import-Module "$here\$sut" -Force

Describe "TestResolvePath" {
    <#
    It "does something useful" {
        $true | Should Be $false
    }
    #>
    It "絶対パスから相対パスへの変換" {
        $base = "C:\Users\qqf73\github"    # 基準となるパス
        $abs  = "C:\Users\qqf73\github\ResolvePathInPowerShell\README.md"    # 絶対パス
        Push-Location $base
            Resolve-Path $abs -Relative | Should Be '.\ResolvePathInPowerShell\README.md'
            $base | Test-Path
            $abs  | Test-Path
        Pop-Location
        # Push-LocationとPop-Locationは関数内でカレントディレクトリを
        # 変更するような処理をlocation stack上で行う。
        # カレントディレクトリが本当に変更すれば呼び出し元の処理に影響が及ぶが
        # スタックを利用することで影響を与えないようにする
    }
    It "相対パスから絶対パスへの変換例" {
        $base = "X:\foo\bar\"
        $rltv = "..\baz.txt"
        $rltv | Convert-LocalPath -Location $base | Should Be "X:\foo\baz.txt"
        $base | Test-Path
        $rltv | Convert-LocalPath -Location $base | Test-Path
    }
}
