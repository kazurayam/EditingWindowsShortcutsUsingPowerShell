$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
# . "$here\$sut"

Describe "組み込みコマンドレット Resolve-Path を試す" {
    <#
    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/resolve-path?view=powershell-7
    #>
    It "カレントフォルダを基底とする相対パスを絶対パスへ変換する" {
        $currentDir = Get-Location
        # Write-Host "currentDir is ${currentDir}"
        $base = Join-Path $currentDir "src\test\fixture"
        # Write-Host "base is ${base}"
        $target = "subfolder\moreLinkToAppData.lnk"
        # Write-Host "target is ${target}"
        Push-Location -Path $base
        try {
            Resolve-Path -Path $target | Should Match '^C:\\Users'cd
            Resolve-Path -Path $target | Should Match '\\moreLinkToAppData.lnk$'
        } finally {
            Pop-Location
        }
        <#
        Push-LocationとPop-Locationは関数内でカレントディレクトリを変更するような処理をlocation stack上で行う。
        カレントディレクトリが本当に変更すれば呼び出し元の処理に影響が及ぶのでややこしいことになるが、
        Push-LocationとPop-Locationを使うことによりカレントディレクトリに影響を与えずにパスの変換処理を実行することができる。
        #>
    }

    It "絶対パスをうけとって、.\src\test\fixture\powershellフォルダを基底とする相対パスへ変換する" {
        $currentDir = Get-Location
        $base = Join-Path $currentDir "src\test\fixture"
        $target = Join-Path $base "subfolder\moreLinkToAppData.lnk"
        Push-Location -Path $base
        try {
            Resolve-Path -Path $target -Relative | Should Be '.\subfolder\moreLinkToAppData.lnk'
        } finally {
            Pop-Location
        }

    }
}
