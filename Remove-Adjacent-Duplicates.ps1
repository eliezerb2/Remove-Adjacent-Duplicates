// TODO: define param as a class and reuse for all functions
param (
    [Parameter(Mandatory=$true)]
    [string]$originalFileName,
    [string]$newFileName,
    [string]$confirm
)

function Confirm-Parameters {
    param (
        [Parameter(Mandatory=$true)]
        [string]$originalFileName,
        [string]$newFileName,
        [string]$confirm
    )

    if (-not (Test-Path $originalFileName)) {
        Write-Error "File '$originalFileName' does not exist."
        return $false
    }

    if ($newFileName -and (Test-Path $newFileName)) {
        if ($confirm -notin @('y', 'yes', 'all')) {
            $userConfirm = Read-Host "File '$newFileName' already exists. Do you want to overwrite it? (y/n)"
            if ($userConfirm -ne 'y') {
                return $false
            }
        }
    }

    return $true
}

function Remove-Adjacent-Duplicates {
    param (
        [Parameter(Mandatory=$true)]
        [string]$originalFileName,
        [string]$newFileName,
        [string]$confirm
    )

    if (-not (Confirm-Parameters -originalFileName $originalFileName -newFileName $newFileName -confirm $confirm)) {
        return
    }

    if (-not $newFileName) {
        $newFileName = $originalFileName
    }

    $prevLine = $null
    Get-Content $originalFileName | ForEach-Object {
        if ($_ -ne $prevLine) {
            $_
            $prevLine = $_
        }
    } > $newFileName
}

# Call the function
Remove-Adjacent-Duplicates -originalFileName $originalFileName -newFileName $newFileName -confirm $confirm