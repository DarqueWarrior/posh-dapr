Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load posh-dapr module from current directory
Import-Module .\posh-dapr

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
# Import-Module posh-dapr

Pop-Location