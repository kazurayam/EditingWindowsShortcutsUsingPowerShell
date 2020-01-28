$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
# . "$here\$sut"

Describe "Windowsショートカットにたいして様々の操作を試す" {
    
    $currentDir = Get-Location
    $workDir = Join-Path $currentDir "build\tmp\testOutput\ShortcutOperations"
    $wsh = New-Object -ComObject WScript.shell 

    It "既にあるショートカットのリンク先を読み出す" {
        $path = Join-Path $workDir "subfolder\moreLinkToAppData.lnk"
        $shortcut = $wsh.createShortcut($path)
        $target = $shortcut.targetPath
        # このショートカットのリンク先は C:\Users\qcq0264\AppData であるはず
        # Write-Host "targetPath is ${targetPath}"
        $target | Should Match "^C:\\Users"
        $target | Should Match "\\AppData$"
    }

    It "wordirフォルダの下にあるすべてのショートカットのリンク先を読み出す" {
        Get-ChildItem $workDir -Recurse -Filter *.lnk | ForEach-Object {
            $path = $_.FullName
            $shortcut = $wsh.createShortcut($path)
            $target = $shortcut.targetPath
            # Write-Host "${path} has targetPath=${targetPath}"
            $target | Should Match "\\AppData$"
        }
    }

    It "既にあるショートカットのリンク先を C:\Users\xxxx\AppData から C:\Users\xxxx\AppData\Roaming\Google\Chrome に変更して保存する" {
        $path = Join-Path $workDir "subfolder\moreLinkToAppData.lnk"
        $shortcut = $wsh.createShortcut($path)
        if ($shortcut.targetPath -Match 'AppData$') {
            # 新しく設定するリンク先文字列を求めて
            $targetPath = $shortcut.targetPath -replace 'AppData$', 'AppData\Roaming\Google\Chrome'
            # ショートカットを変更する
            $new = $wsh.createShortcut($path)
            $new.targetPath = $targetPath
            $new.save()
            # ショートカットのtargetPathが期待した値に変更されているかどうか確かめる
            $shrt = $wsh.createShortcut($path)
            $shrt.targetPath | Should Match 'Chrome$'
        }
    }

    It "あるフォルダの下にあるすべてのショートカットのリンク先を変更して保存する" {
        Get-ChildItem $workDir -Recurse -Filter *.lnk | ForEach-Object {
            $path = $_.FullName
            $shortcut = $wsh.createShortcut($path)
            if ($shortcut.targetPath -Match 'AppData$') {
                # 新しく設定するリンク先文字列を求めて
                $targetPath = $shortcut.targetPath -replace 'AppData$', 'AppData\Roaming\Google\Chrome'
                # ショートカットを変更する
                $new = $wsh.createShortcut($path)
                $new.targetPath = $targetPath
                $new.save()
                # ショートカットのtargetPathが期待した値に変更されているかどうか確かめる
                $shrt = $wsh.createShortcut($path)
                $shrt.targetPath | Should Match 'Chrome$'
            }
        }
    }

    BeforeEach {
        # srcの下にあるfixtureをbuildにコピーする
        # 各テストがfixtureを変更しても他テストに影響を及ぼさないようにするため
        $source = Join-Path $currentDir "src/test/fixture"
        $destination = $workDir
        # destionationディレクトリがすでにあったらそれを削除する
        if (Test-Path $destination) {
            Remove-Item $destination -Force -Recurse
        }
        # destinationディレクトリを再作成する
        New-Item $destination -ItemType Directory
        # *.lnkファイルをsourceからdestinationへコピーする
        Get-ChildItem $source | Copy-Item -Filter *.lnk -Recurse -Destination $destination -Container 
    }
}
