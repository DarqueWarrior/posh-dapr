param([switch]$WhatIf = $false)

if($PSVersionTable.PSVersion.Major -lt 2) {
    Write-Warning "posh-dapr requires PowerShell 2.0 or better; you have version $($Host.Version)."
    return
}

if(!(Get-Command dapr -ErrorAction SilentlyContinue)) {
    Write-Warning 'Could not find dapr command. Please create an dapr alias or add its location to PATH.'
    return
}

$installDir = Split-Path $MyInvocation.MyCommand.Path -Parent
if(!(Test-Path $PROFILE)) {
    Write-Information "Creating PowerShell profile...`n$PROFILE"
    New-Item $PROFILE -Force -Type File -ErrorAction Stop -WhatIf:$WhatIf > $null
}

# Adapted from http://www.west-wind.com/Weblog/posts/197245.aspx
function Get-FileEncoding($Path) {
    $bytes = [byte[]](Get-Content $Path -Encoding byte -ReadCount 4 -TotalCount 4)

    if(!$bytes) { return 'utf8' }

    switch -regex ('{0:x2}{1:x2}{2:x2}{3:x2}' -f $bytes[0],$bytes[1],$bytes[2],$bytes[3]) {
        '^efbbbf'   { return 'utf8' }
        '^2b2f76'   { return 'utf7' }
        '^fffe'     { return 'unicode' }
        '^feff'     { return 'bigendianunicode' }
        '^0000feff' { return 'utf32' }
        default     { return 'ascii' }
    }
}

$profileLine = ". '$installDir\profile.example.ps1'"
if(Select-String -Path $PROFILE -Pattern $profileLine -Quiet -SimpleMatch) {
    Write-Information "It seems posh-dapr is already installed..."
    return
}

Write-Information "Adding posh-dapr to profile..."
@"

# Load posh-dapr example profile
$profileLine

"@ | Out-File $PROFILE -Append -WhatIf:$WhatIf -Encoding (Get-FileEncoding $PROFILE)

Write-Information 'posh-dapr sucessfully installed!'
Write-Information 'Please reload your profile for the changes to take effect:'
Write-Information '    . $PROFILE'