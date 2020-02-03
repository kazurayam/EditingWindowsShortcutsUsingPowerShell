$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$currentDir = Get-Location

# テスト対象であるfunctionを読み込む
$sut = (Join-Path $currentDir 'src\main\powershell\GetShortcutTargetPath.psm1')
Import-Module $sut -function *

Describe "Get-ShortcutTargetPath関数をテストする" {

    $workDir = Join-Path $currentDir "build\tmp\testOutput\GetShortcutTargetPath"

    It "ひとつのショートカットのtargetPathを読み出す --- ショートカットが存在する場合" {
        $shrt = Join-Path $workDir "subfolder\moreLinkToAppData.lnk"
        Get-ShortcutTargetPath -Shortcut $shrt | Should Be 'C:\Users\qcq0264\AppData' 
    }

    BeforeEach {
        # srcの下にあるfixtureをbuildの下にコピーする
        $source = Join-Path $currentDir "src/test/fixture"
        $destination = $workdir
        # destinationディレクトリが既にあったらそれを削除する
        if (Test-Path $destination) {
            Remove-Item $destination -Force -Recurse
        }
        # destinationディレクトリを再作成する
        New-Item $destination -ItemType Directory
        # *.lnkファイルをsourceからdestinationへコピーする
        Get-ChildItem $source | Copy-Item -Filter *.lnk -Recurse -Destination $destination -Container
    }
}