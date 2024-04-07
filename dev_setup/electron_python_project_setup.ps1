param (
    [Parameter(Mandatory = $true)]
    [string]$electronDir
)

# Navigate to the Electron app directory
Set-Location $electronDir

function get_yes_or_no($question) {
    # Define the lists of valid positive and negative responses
    $positiveResponses = "yes", "y", "sure"
    $negativeResponses = "no", "nope"

    while ($true) {
        $answer = Read-Host "$question (yes/no) [no]"

        if ($answer -eq "") {
            $answer = "no"
        }

        # Check if the user's answer is valid
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

# Check if Node.js and npm are installed
$nodeVersion = $null
$npmVersion = $null

try {
    $nodeVersion = node -v
}
catch {
    Write-Host "Node.js is not installed. Please install Node.js and try again."
    exit
}

try {
    $npmVersion = npm -v
}
catch {
    Write-Host "npm is not installed. Please install npm and try again."
    exit
}

Write-Host "Node.js version: $nodeVersion"
Write-Host "npm version: $npmVersion"

try {
    $latestLTSVersion = nvm ls-remote --lts | tail -1
    Write-Host "Latest LTS version of Node.js: $latestLTSVersion"
}
catch {
    Write-Host "Failed to retrieve the latest LTS version of Node.js."
    exit
}

get_yes_or_no

# Install Electron locally
npm install electron --save-dev

# Create main.js file
@"
const { app, BrowserWindow } = require('electron')

function createWindow () {
    const win = new BrowserWindow({
        width: 800,
        height: 600,
        webPreferences: {
            nodeIntegration: true,
        }
    })

    win.loadFile('index.html')
}

app.whenReady().then(createWindow)
"@ | Out-File -Encoding utf8 main.js

# Create index.html file
@"
<!DOCTYPE html>
<html>
  <body>
    <h1>Hello World!</h1>
    <script>
      // You can also require other files to run in this process
      require('./renderer.js')
    </script>
  </body>
</html>
"@ | Out-File -FilePath index.html

# Create package.json file
@"
{
  "name": "my-electron-app",
  "version": "1.0.0",
  "description": "My Electron app",
  "main": "main.js",
  "scripts": {
    "start": "electron ."
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "electron": "^13.1.7"
  }
}
"@ | Out-File -FilePath package.json


# Start the Electron app
get_yes_or_no("Start the App?")
npm start