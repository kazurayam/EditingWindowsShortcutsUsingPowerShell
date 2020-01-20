$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$currentDir = Get-Location

# テスト対象であるfunctionを読み込む
$sut = (Join-Path $currentDir 'src\main\powershell\ConvertShortcutTargetPath.psm1')
Import-Module $sut -function *

Describe "Convert-ShortcutTargetPath関数をテストする" {

    $workDir = Join-Path $currentDir "build\tmp\testOutput\ConvertShortcutTargetPath"

    It "ひとつのショートカットのtargetPathを書きかえる操作をDryrunする --- 書き換えた結果のディレクトリが存在する場合" {
        $path = Join-Path $workDir "subfolder\moreLinkToAppData.lnk"
        (Convert-ShortcutTargetPath -Shortcut $path -Regexp 'AppData$' -Replacement 'AppData\Roaming\Google\Chrome' -Dryrun) | Should Be $true
    }
    
    It "ひとつのショートカットのtargetPathを書きかえる操作をDryrunする --- 書き換えた結果のディレクトリが存在しない場合" {
        $path = Join-Path $workDir "subfolder\moreLinkToAppData.lnk"
        (Convert-ShortcutTargetPath -Shortcut $path -Regexp 'AppData$' -Replacement 'AppData\Roaming\Google\FOOBAR' -Dryrun) | Should Be $false
    }

    BeforeEach {
        # srcの下にあるfixtureをbuildにコピーする
        # 各テストがfixtureを変更しても他テストに影響を及ぼさないようにするため
        $source = Join-Path $currentDir "src/test/fixture"
        $destination = $workDir
        # destionationディレクトリが既にあったらそれを削除する
        if (Test-Path $destination) {
            Remove-Item $destination -Force -Recurse
        }
        # destinationディレクトリを再作成する
        New-Item $destination -ItemType Directory
        # *.lnkファイルをsourceからdestinationへコピーする
        Get-ChildItem $source | Copy-Item -Filter *.lnk -Recurse -Destination $destination -Container 
    }
}
