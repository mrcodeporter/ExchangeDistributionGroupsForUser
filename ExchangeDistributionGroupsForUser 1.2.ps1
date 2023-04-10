<#
.SYNOPSIS
Retrieves a list of distribution groups that a specified Exchange user is a member of.

.DESCRIPTION
This PowerShell script connects to Exchange Online and retrieves a list of distribution groups that a specified Exchange user is a member of. The script prompts the user to enter the username for which they want to retrieve the distribution groups, and then uses the Get-DistributionGroup cmdlet to filter the results.

.PARAMETER UserName
The username of the Exchange user for which to retrieve distribution groups.

.PARAMETER ExportCSV
Specifies whether to export the output to a CSV file.

.EXAMPLE
.\Get-ExchangeUserDistributionGroups.ps1

This example starts the script and displays the menu to search for a user and export the results to a CSV file.

.INPUTS
None.

.OUTPUTS
A list of distribution group names.

.NOTES
Author: Ervin
Date: 10/04/2023
Version: 1.3

# REQUIREMENTS
This script requires the Exchange Online PowerShell module and PowerShell 5.1 or later.

# TROUBLESHOOTING
- If you receive an error message indicating that the specified username is not found in the Exchange organization, ensure that the username is spelled correctly and that the user exists in the organization.
- If you receive an error message indicating that the Exchange Online PowerShell module is not installed, install the module by running the command 'Install-Module ExchangeOnlineManagement' in PowerShell.
- If you receive any other error messages when running the script, review the error message for clues about the issue and consult the Exchange Online documentation for additional troubleshooting steps.

#>

function Search-ExchangeUserDistributionGroups {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, HelpMessage = "Enter the username.")]
        [string]$UserName,
        [Parameter(HelpMessage = "Export the output to a CSV file.")]
        [switch]$ExportCSV
    )
}
    #Connect to Exchange Online
    Connect-ExchangeOnline 

    #Get all the groups that the user is a member of
    $groups = Get-DistributionGroup -ResultSize Unlimited | Where-Object { (Get-DistributionGroupMember $_.DistinguishedName | Select-Object -ExpandProperty PrimarySmtpAddress) -contains $UserName } | Select-Object -ExpandProperty Name

    if ($groups.Count -eq 0) {
        Write-Host "User '$UserName' was not found in the Exchange organization. Please try again."
        $newUser = Read-Host "Enter another username to search, or enter 'exit' to exit."
        if ($newUser -ne 'exit') {
            Search-ExchangeUserDistributionGroups -UserName $newUser -ExportCSV:$ExportCSV
        }
        else {
            Write-Host "Exiting search..."
        }
    }
    else {
        #Display the groups
        Write-Host "User '$UserName' is a member of the following groups in Exchange:"
        foreach ($group in $groups) {
            Write-Host $group
        }


#Export to CSV
if ($ExportCSV) {
    $csvPath = "C:\temp\$UserName.csv"
    $groups | Export-Csv -Path $csvPath -NoTypeInformation
    Write-Host "Group membership information saved to $csvPath."
}

#Search for another user or disconnect
$continue = Read-Host "Do you want to search for another user? (Y/N)"
if ($continue.ToUpper() -eq 'Y') {
    Show-Menu
}
else {
    Write-Host "Disconnecting from Exchange Online..."
    Disconnect-ExchangeOnline
}
}

function Show-Menu {
    Write-Host "============================"
    Write-Host "  Exchange User Lookup Menu  "
    Write-Host "============================"
    Write-Host "1. Search for user"
    Write-Host "2. Export results to CSV"
    Write-Host "3. Exit"

    $choice = Read-Host "Enter your choice"
    switch ($choice) {
        '1' { Search-ExchangeUser }
        '2' { Export-CSV }
        '3' { Write-Host "Exiting script..."; Disconnect-ExchangeOnline; break }
        default { Write-Host "Invalid choice. Please try again." }
    }
}

function Search-ExchangeUser {
    $user = Read-Host "Enter the username to search for."
    $export = Read-Host "Export the output to a CSV file? (Y/N)"
    if ($export.ToUpper() -eq 'Y') {
        Search-ExchangeUserDistributionGroups -UserName $user -ExportCSV:$true
    }
    else {
        Search-ExchangeUserDistributionGroups -UserName $user
    }
}

function Export-CSV {
    $user = Read-Host "Enter the username to export group membership for."
    Search-ExchangeUserDistributionGroups -UserName $user -ExportCSV:$true
}

Show-Menu
