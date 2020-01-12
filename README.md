PowerShellでWindowsのショートカットを一括して書きかえた、リンク先を絶対パスから相対パスに変更した
==============

# 解決すべき問題

## はじまり

自分が関わる開発プロジェクトのSubversionレポジトリをGitHub Enterpriseへ移行する作業を始めた。そのプロジェクトはWindowsを前提しており、ファイルツリーのなかに約300個のショートカットがあった。ショートカットには属性としてリンク先があってそこにフォルダのパスが絶対パスで書いてあった。たとえば `C:\SVNReposX\contents\aaaa\code` のように。いっぽうGitレポジトリを `C:\GheReposX` の下に作ってSubversionから移行した。するとショートカットのリンク先が `C:\SVNReposX\...` だから切れてしまった。リンク切れを解消しなければならない。そもそもショートカットのリンク先に絶対パスを書くと融通がきかない。ショートカット自身を基底とする相対パスを書くべきだ。


## 技術要素としての問題

1. あるフォルダの下にあるショートカット（ファイル名の末尾が`.lnk`であるファイル）を一括して取得したい
2. ショートカットのリンク先がいまどういう値に設定されているかをREADしたい。
3. リンク先(フォルダ)のリンク先が絶対パスであるならば、ショートカット自身を基底とする相対パスに変換したい
4. リンク先を更新したショートカットのをWRITEしたい。


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
- [PowerShell フォルダ内のファイル一覧を取得し、一括でファイル操作を行う](htVtps://mseeeen.msen.jp/how-to-get-list-of-files-in-folder-with-powershell/)



```
New-Fixture -Path $env:USERPROFILE\Documents\WindowsPowerShell\Modules\FizzBuzz -Name FizzBuzz
```