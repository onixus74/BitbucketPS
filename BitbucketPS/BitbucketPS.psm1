# Load configuration using
# https://github.com/PoshCode/Configuration
$script:Configuration = Configuration\Import-Configuration -CompanyName "AtlassianPS" -Name "BitbucketPS"

# Load the ConfluencePS namespace from C#
if (!("BitbucketPS.Server" -as [Type])) {
    Add-Type -Path (Join-Path $PSScriptRoot BitbucketPS.Types.cs) -ReferencedAssemblies Microsoft.CSharp, Microsoft.PowerShell.Commands.Utility, System.Management.Automation
}

# Load Web assembly when needed
# PowerShell Core has the assembly preloaded
if (!("System.Web.HttpUtility" -as [Type])) {
    Add-Type -Assembly System.Web
}

$PublicFunctions = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$PrivateFunctions = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

# Dot source the functions
ForEach ($file in @($PublicFunctions + $PrivateFunctions)) {
    Try {
        . $file.FullName
    }
    Catch {
        $errorItem = [System.Management.Automation.ErrorRecord]::new(
            ([System.ArgumentException]"Function not found"),
            'Load.Function',
            [System.Management.Automation.ErrorCategory]::ObjectNotFound,
            $file
        )
        $errorItem.ErrorDetails = "Failed to import function $($file.BaseName)"
        Throw $errorItem
    }
}
