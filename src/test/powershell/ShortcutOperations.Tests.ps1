$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
# . "$here\$sut"

Describe "Windowsショートカットにたいして様々の操作を試す" {
    It "既にあるショートカットのリンク先を読み出して表示する" {
        Write-Host "Hello"
    }

    It "既にあるショートカットのリンク先を変更して保存する" {
    }

    It "あるフォルダの下にあるすべてのショートカットのリンク先を読み出して表示する" {

    }

    It "あるフォルダの下にあるすべてのショートカットのリンク先を変更して保存する" {

    }

    BeforeEach {
        # srcの下にあるfixtureをbuildにコピーする
        # 各テストがfixtureを変更しても他テストに影響を及ぼさないようにするため
        $currentDir = Get-Location
        $source = Join-Path $currentDir "src/test/fixture"
        $destination = Join-Path $currentDir "build\tmp\testOutput\ShortcutOperations"
        # clean the destionation 
        Remove-Item $destination -Force -Recurse
        New-Item $destination -ItemType Directory
        # copy files from source to destination
        Get-ChildItem $source | Copy-Item -Filter *.lnk -Recurse -Destination $destination -Container 
    }
}
