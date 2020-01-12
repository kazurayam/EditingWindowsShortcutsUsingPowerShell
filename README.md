PowerShellでWindowsのショートカットを一括して書きかえた、リンク先を絶対パスから相対パスに変更した
==============

# 解決すべき問題

## はじまり

自分が関わる開発プロジェクトのSubversionレポジトリをGitHub Enterpriseへ移行する作業を始めた。そのプロジェクトはWindowsを前提しており、ファイルツリーのなかに約300個のショートカットがあった。ショートカットには属性としてリンク先があってそこにフォルダのパスが絶対パスで書いてあった。たとえば `C:\SVNReposX\contents\aaaa\code` のように。いっぽうGitレポジトリを `C:\GheReposX` の下に作ってSubversionから移行した。するとショートカットのリンク先が `C:\SVNReposX\...` だから切れてしまった。リンク切れを解消しなければならない。

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

- Windows 10
- .NET Framework
- PowerShell
- Visual Studio Code
- Pester

## テストの実行

VS CodeのTerminalを使う。

```
PS C:\...> cd <EditingWindowsShortCutsUsingPowerShellのフォルダ>
PS C:\...\EditingWindowsShortCutsUsingPowerShell> Invoke-Pester
```


# 参考情報

- [Pesterを使ったPowerShellモジュールのテスト駆動開発](https://qiita.com/yuki451/items/68d4b1f0bc235f7f318d)
- [PowerShellで絶対パスと相対パスを相互変換したい](https://qiita.com/yumura_s/items/0aed4c275432993e9174)
- [PowerShell フォルダ内のファイル一覧を取得し、一括でファイル操作を行う](https://mseeeen.msen.jp/how-to-get-list-of-files-in-folder-with-powershell/)



```
New-Fixture -Path $env:USERPROFILE\Documents\WindowsPowerShell\Modules\FizzBuzz -Name FizzBuzz
```