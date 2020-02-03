function Get-ShortcutTargetPath {
    param(
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [string]
        $Shortcut
    )

    <#
        .SYNOPSIS
        read the shortcut and output its targetPath value

        .DESCRIPTION

        .PARAMETER Shortcut
        a string as shortcut's path

        .INPUTS
        reads the shortcut at the -Shortcut parameter

        .OUTPUTS
        outputs the value of targetPath into the pipeline

        .EXAMPLE
        C:\PS .\Convert-ShortcutTargetPath -Shortcut "C:\Users\myname\EditingWindowsShortcutsUsingPowerShell\build\tmp\testOutput\ConvertShotcutTragetPath\linkToAppData.lnk"

        .LINK
    #>

    # Windows Script Host
    $wsh = New-Object -ComObject WScript.Shell

    $result = ''
    if (Test-Path -Path $Shortcut) {
        if ($Shortcut -Match '\.lnk') {
            $shrt = $wsh.createShortcut($Shortcut)
            $result = $shrt.targetPath
        } else {
            Write-Warning "${Shortcut} does not ends with .lnk"
        }
    } else {
        Write-Warning "${Shortcut} is not found"
    }
    $result
}