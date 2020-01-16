Windowsのショートカットを一括して書きかえたい、PowerShellで
==============

# 解決すべき問題

## はじまり

自分が関わる開発プロジェクトのSubversionレポジトリをGitHub Enterpriseへ移行する作業を始めた。そのプロジェクトはWindowsを前提しており、ファイルツリーのなかに約300個のショートカットがあった。ショートカットには属性としてリンク先があって、フォルダのパスが絶対パスで書いてあった。たとえば `C:\SVNReposX\contents\aaaa\code` のように。わたしはGitレポジトリを `C:\GheReposX` の下に作ってSubversionから移行したのだが、ショートカットのリンク先が `C:\SVNReposX\...` と書いてあって `C:\GheReposX\...` とは書いていない。つまりショートカットがリンク切れの状態になった。Windowsエクスプローラーでショートカットをダブルクリックすると下記のようなエラーになった。

![場所が利用できません](docs/images/brokenLink.png)

リンク切れを解消しなければならない。

## 技術要素としての問題

1. あるフォルダの下にあるショートカット（ファイル名の末尾が`.lnk`であるファイル）を一括して取得したい
2. ショートカットのリンク先がいまどういう値に設定されているかをREADしたい。
3. リンク先(フォルダ)のリンク先が絶対パスであるならば、ショートカット自身を基底とする相対パスに変換したい
4. リンク先を更新したショートカットのをWRITEしたい。

## 絶対パスか相対パスか

そもそもショートカットのリンク先に絶対パスを書くと融通がきかないから、ショートカット自身を基底とする相対パスを書くべきだ、という考えもあった。スクリプトを駆使してリンク先を編集し相対パスにすることは可能性だ。

- [相対パスの指定方法](https://dulunoj.com/2018/02/13/%E7%9B%B8%E5%AF%BE%E3%83%91%E3%82%B9%E3%81%AE%E6%8C%87%E5%AE%9A%E6%96%B9%E6%B3%95/)

しかしながらショートカットを新規に作るにはふつうWindowsのエクスプローラーで右クリックして *新規作製 > ショートカット* とやるが、そのやり方では **リンク先に必ず絶対パスが設定される。** ふつうのやり方でショートカットのリンク先に相対パスを指定することはできない。だからショートカットを相対パスで指定するというやり方は可能ではあるがじっさい運用できないといわざるをえない。

いまわたしがショートカットのリンク先を書きかえるツールを作るならば、絶対パスを相対パスに書きかえるのではなく、与えられた絶対パスを別の絶対パスに書きかえることができるツールを作るほうが実用的だ。

# 解決方法

PowerShellでスクリプトを書こう。ぜんぶ解決できる。


# 説明

## 環境

- Windows 10 Pro
- .NET Framework (ver 4.7.03190)
- PowerShell (プログラミング言語)
- Visual Studio Code (エディタ)
- Pester (PowerShellのユニット・テストframework)

## テストの実行

VS CodeのTerminalを使う。

```
PS C:\...> cd <EditingWindowsShortCutsUsingPowerShellのフォルダ>
PS C:\...\EditingWindowsShortCutsUsingPowerShell> Invoke-Pester
```


# 参考情報

## PowerShell言語に組み込まれたPathにかんするコマンドレット

- [@IT WindowsのPowerShellでパス文字列を操作する](https://www.atmarkit.co.jp/ait/articles/0809/12/news139.html)
- [Convert-Path カレントフォルダを基点として、与えられた相対パスを絶対パスに変換する](https://forsenergy.com/ja-jp/windowspowershellhelp/html/60cd1f85-c580-454a-8df5-f8ec4ce44a34.htm)
- [Join-Path パスと子パスを結合する](https://forsenergy.com/ja-jp/windowspowershellhelp/html/2c0230a1-fe6b-40f5-8fd2-926ce631b402.htm)
- [Split-Path パスの要素を返す](https://forsenergy.com/ja-jp/windowspowershellhelp/html/efafd4b3-e5cf-4899-b693-3b4a0d91d01a.htm)
- [Test-Path パスのすべての要素が存在するかどうかを確認する](https://forsenergy.com/ja-jp/windowspowershellhelp/html/bce28e12-dc29-4ffd-8f1c-28f877931ebf.htm)
- [Resolve-Path ](https://forsenergy.com/ja-jp/windowspowershellhelp/html/69809773-ce6e-4128-9526-3eaf4b5dc6d5.htm)

##
- [Pesterを使ったPowerShellモジュールのテスト駆動開発](https://qiita.com/yuki451/items/68d4b1f0bc235f7f318d)
- [PowerShellで絶対パスと相対パスを相互変換したい](https://qiita.com/yumura_s/items/0aed4c275432993e9174)
- [PowerShell フォルダ内のファイル一覧を取得し、一括でファイル操作を行う](https://mseeeen.msen.jp/how-to-get-list-of-files-in-folder-with-powershell/)



```
New-Fixture -Path $env:USERPROFILE\Documents\WindowsPowerShell\Modules\FizzBuzz -Name FizzBuzz
```

# すべての*ps1ファイルをUTF-8 BOMつきに変換する

BOM無しのUTF-8で作った.ps1ファイルをPesterで実行したらメッセージのなかの日本語文字が化けてしまいました。どうやら .ps1 ファイルはUTF-8 BOMつきでなければならないようです。

下記の記事を参考に、あるフォルダ配下のすべての.PS1ファイルをBOM有りUTF-8に変換するPowerShellスクリプトを用意しました。

[WindowsですべてのUTF-8ファイルにBOMを付ける、たったひとつの冴えたやり方](https://qiita.com/aokomoriuta/items/b1182d310ec4ef2d76b7)

```
get-childitem * -include *.ps1 -Recurse | foreach-object {((&{if ((Compare-Object (get-content $_.FullName -encoding byte)[0..2] @(0xEF, 0xBB, 0xBF)).length -eq 0){ @() } else { ([byte[]] @(0xEF, 0xBB, 0xBF)) } }) + (get-content $_.FullName -encoding byte)) | set-content $_.FullName -encoding byte}
```