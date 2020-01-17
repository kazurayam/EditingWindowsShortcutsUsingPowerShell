function Convert-ShortcutTargetPath {
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Shortcut,
        
        [Parameter(Mandatory=$true)]
        [string]
        $Regex,
        
        [Parameter(Mandatory=$true)]
        [string]
        $Replacement,

        [Parameter(Mandatory=$false)]
        [switch]
        $Dryrun=$false

    )

    <#
        .SYNOPSIS
        convert the targetPath property of a Windows Shortcut

        .DESCRIPTION

        .PARAMETER Shortcut
        a string as a path the a shortcut

        .PARAMETER Regexp
        the targetPath of the shortcut is edited using substituting a string with "-replace Regexp,Replacement"

        .PARAMETER Replacement
        the targetPath of the shortcut is edited using substituting a string with "-replace Regexp,Replacement"

        .PARAMETER Dryrun
        if set, dry-run is performed. The shortcut will not be updated. Errors will be reported if any. 

        .INPUTS
        reads the shortcut at the -Shorcut parameter

        .OUTPUTS
        overwrites the shortcut at the -ShortcutParemter 

        .EXAMPLE
        C:\PS .\Convert-ShortcutTargetPath -Shortcut "C:\Users\myname\EditingWindowsShortcutsUsingPowerShell\build\tmp\testOutput\ConvertShotcutTragetPath\linkToAppData.lnk" -Regexp 'AppData$' -Replacement 'AppData\Roaming\Google\Chrome'

        .LINK
    #>

    # Windows Script Host
    $wsh = New-Object -ComObject WScript.shell
    
    $result = $true
    if (Test-Path -Path $Shortcut) {
        if ($Shortcut -Match '\.lnk') {
            try {
                $shrt = $wsh.createShortcut($Shortcut)
                $replaced = $shrt.targetPath -replace $Regexp, $Replacement
                if ((Test-Path $replaced)) {
                    if ($Dryrun) {
                        # calculate the replacement and check if the file exists
                        Write-Host "  Shortcut: ${Shortcut}"
                        Write-Host "    target path: ${$shortcut.targetPath}"
                        Write-Host "    replaced to: ${replaced}"
                    } else {
                        # overwrite the shortcut with the replaced targetPath
                        $new = $wsh.createShortcut($Shortcut)
                        $new.targetPath = $replaced
                        $new.save()
                    }
                } else {
                    Write-Host "! Shortcut: ${Shortcut}"
                    Write-Host "    target path: ${$shortcut.targetPath}"
                    Write-Host "    replaced to: ${replaced} <= does not exist"
                    $result = $false
                }
            } catch {
                Write-Host $.Exception.Message
                $result = $false
            }
        } else {
            Write-Host "${Shortcut} does not ends with .lnk"
            $result = $false
        }
    } else {
        Write-Host "${Shortcut} is not found"
        $result = $false
    }

    return $result

}