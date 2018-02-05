[CmdletBinding()]
param(
    [ValidateSet("Bootstrap", "Final")]
    [string]$Version = "Bootstrap",

    [string]$Architecture = "",

    [ValidateSet("Debug", "Release")]
    [string]$Release = "Debug"
)

if ($Version -eq "Bootstrap") {
    $re2c = "re2c.bootstrap.exe"
} else {
    $re2c = "re2c.exe"
}

$path_to_executables = Join-Path -Path $PSScriptRoot -ChildPath "re2c"  | `
                       Join-Path -ChildPath $Architecture | `
                       Join-Path -ChildPath $Release

if (-not (Test-Path -Path $path_to_executables -PathType Container)) {
    Write-Error -Message "Cannot find directory '$path_to_executables'"
    return
}

$test_executables = @(
    "range.exe"
    "s_to_n32_unsafe.exe"
)

foreach($executable in $test_executables) {
    $full_path = Join-Path -Path $path_to_executables -ChildPath $executable
    if (-not (Test-Path $full_path -PathType Leaf)) {
        Write-Warning -Message "Cannot find test executable '$executable' in '$full_path'"
    } else {
        & $full_path
        $lec = $LASTEXITCODE
        if ($lec -eq 0) {
            Write-Verbose -Message "Test executable '$executable': OK"
        } else {
            Write-Error -Message "Test executable '$executable' returned error: $lec"
        }
    }
}