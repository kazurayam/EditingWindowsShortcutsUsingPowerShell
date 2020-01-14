$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1', '.psm1'
Import-Module "$here\$sut" -Force

Describe "コマンドレット Resolve-Path を試す" {
    <#
    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/resolve-path?view=powershell-7
    #>
    It "絶対パスから相対パスへの変換" {
        $base = "${env:USERPROFILE}\github"    # 基準となるパス
        $abs  = "${env:USERPROFILE}\github\EditingWindowsShortcutsUsingPowerShell\README.md"    # 絶対パス
        Push-Location $base
        try {
            Resolve-Path $abs -Relative | Should Be '.\EditingWindowsShortcutsUsingPowerShell\README.md'
            $base | Test-Path
            $abs  | Test-Path
        } finally {
            Pop-Location
        }
        <#
        Push-LocationとPop-Locationは関数内でカレントディレクトリを変更するような処理をlocation stack上で行う。
        カレントディレクトリが本当に変更すれば呼び出し元の処理に影響が及ぶのでややこしいことになるが、
        Push-LocationとPop-Locationを使うことによりカレントディレクトリに影響を与えずにパスの変換処理を実行することができる。
        #>
    }
    It "相対パスから絶対パスへの変換例" {
        $base = "X:\foo\bar\"
        $rltv = "..\baz.txt"
        $rltv | Convert-LocalPath -Location $base | Should Be "X:\foo\baz.txt"
        $base | Test-Path
        $rltv | Convert-LocalPath -Location $base | Test-Path
    }
}
