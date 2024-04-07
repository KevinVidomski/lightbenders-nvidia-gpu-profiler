param (
    [Parameter(Mandatory = $true)]
    [string]$directory
)

function Request-UserConfirmation($question) {
    $positiveResponses = "yes", "y", "sure"
    $negativeResponses = "no", "nope"

    while ($true) {
        $answer = Read-Host "$question (yes/no) [no]"

        if ($answer -eq "") {
            $answer = "no"
        }

        if ($answer -in $positiveResponses) {
            return
        }
        elseif ($answer -in $negativeResponses) {
            Write-Host "Bye!"
            exit
        }
        else {
            Write-Host "Invalid response. Please enter 'yes' or 'no'."
        }
    }
}

# Record the current directory so that we can return to it once the script is done.
$originalDirectory = Get-Location

# Ask the user if they want to setup the src\python directory
$setupPythonDirectory = Join-Path -Path $directory -ChildPath "setup\python"
New-Item -ItemType Directory -Force -Path $setupPythonDirectory
Request-UserConfirmation "Do you want to setup the src\python directory?"

# Create the src\python directory
$pythonDirectory = Join-Path -Path $directory -ChildPath "src\python"
New-Item -ItemType Directory -Force -Path $pythonDirectory

# Initialize a new npm project
npm init -y

# Install nvidia-smi Python wrapper for the current project
Write-Host "Installing nvidia-smi package..."
npm install --save @nvidia/smi

Write-Host "src\python directory has been set up at $pythonDirectory"

Set-Location $originalDirectory
