$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
# . "$here\$sut"

Describe "Windowsショートカットにたいして様々の操作を試す" {
    
    $currentDir = Get-Location
    $workdir = Join-Path $currentDir "build\tmp\testOutput\ShortcutOperations"

    It "既にあるショートカットのリンク先を読み出して表示する" {
        Write-Host "Hello"
        $path = Join-Path $workdir "subfolder\moreLinkToAppData.lnk"
        $wsh = New-Object -ComObject WScript.shell 
        $shortcut = $wsh.createShortcut($path)
        $targetPath = $shortcut.targetPath    # C:\Users\qcq0264\AppData
        $targetPath | Should Match "^C:\\Users"
        $targetPath | Should Match "\\AppData$"

    }

    It "あるフォルダの下にあるすべてのショートカットのリンク先を読み出して表示する" {
    }

    It "既にあるショートカットのリンク先を変更して保存する" {
    }

    It "あるフォルダの下にあるすべてのショートカットのリンク先を変更して保存する" {
    }

    BeforeEach {
        # srcの下にあるfixtureをbuildにコピーする
        # 各テストがfixtureを変更しても他テストに影響を及ぼさないようにするため
        $source = Join-Path $currentDir "src/test/fixture"
        $destination = $workdir
        # destionationディレクトリを削除し再作成する
        Remove-Item $destination -Force -Recurse
        New-Item $destination -ItemType Directory
        # *.lnkファイルをsourceからdestinationへコピーする
        Get-ChildItem $source | Copy-Item -Filter *.lnk -Recurse -Destination $destination -Container 
    }
}
