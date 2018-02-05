#Requires -Module psake

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

function Assert-Continue {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        Write-Warning -Message "Error: $Message"
    }
}

$path_to_executables = Join-Path -Path $PSScriptRoot -ChildPath "re2c"  | `
                       Join-Path -ChildPath $Architecture | `
                       Join-Path -ChildPath $Release

Assert (Test-Path -Path $path_to_executables -PathType Container) -failureMessage "Cannot find output folder in '$path_to_executables'"

$re2c = Join-Path -Path $path_to_executables -ChildPath $re2c
Assert (Test-Path -Path $re2c -PathType Leaf) -failureMessage "Cannot find re2c executable in '$re2c'"

$test_executables = @(
    "range.exe"
    "s_to_n32_unsafe.exe"
)

# First, check that the simple test applications return the expected result
foreach($executable in $test_executables) {
    $full_path = Join-Path -Path $path_to_executables -ChildPath $executable
    if (-not (Test-Path $full_path -PathType Leaf)) {
        Write-Warning -Message "Cannot find test executable '$executable' in '$full_path'"
    } else {
        & $full_path
        Assert-Continue -Condition ($LASTEXITCODE -Eq 0) -Message "Error code for '$executable' was expected to be 0, got $LASTEXITCODE"
    }
}

# Second, go through the examples directory
$examples_directory = Join-Path -Path $PSScriptRoot -ChildPath .. | `
                      Join-Path -ChildPath 're2c' | `
                      Join-Path -ChildPath 'examples'
$examples = Get-ChildItem -Path $examples_directory -Filter *.re
foreach($example in $examples) {
    Write-Verbose -Message "Examining '$($example.BaseName)'"

    [string[]]$arguments = @()

    if ($example.BaseName.Contains('--tags')) {
        $arguments += "-T"
    }
    if ($example.BaseName.Contains('cr8i')) {
        $arguments += @("-r", "-c")
    }

    [string]$result = & $re2c @arguments $example.FullName
    Assert-Continue -Condition ([string]::IsNullOrWhiteSpace($result) -eq $false) -Message "Got empty output for '$example'"
}
