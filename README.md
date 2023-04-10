# ExchangeDistributionGroupsForUser
"Exchange Online Distribution Groups Management" is a PowerShell script that retrieves and filters a list of distribution groups that a specified user is a member of in Exchange Online.


This PowerShell script was created by Mr.Code.Porter enables users to retrieve a list of distribution groups that a specified user is a member of in Exchange Online. It begins by connecting to Exchange Online through the Connect-ExchangeOnline cmdlet and prompts the user to input the username for which they want to retrieve the distribution groups.

Next, the script utilizes the Get-DistributionGroup cmdlet to retrieve all distribution groups in the organization and filters the results using the Where-Object cmdlet to only include the groups that the specified user is a member of. This is achieved by verifying if the PrimarySmtpAddress property of each group member matches the specified username.

The script then displays the names of the distribution groups that the specified user is a member of using the Write-Host cmdlet and a for each loop. Furthermore, it also provides an additional feature of saving the retrieved list to a CSV file using the Export-CSV cmdlet. This functionality allows users to save and analyze the data later on.

In summary, Mr.Code.Porter's PowerShell script provides a simple yet effective method to retrieve a list of distribution groups that a particular user is a member of in Exchange Online, along with the capability of saving the list to a CSV file for future reference. However, testing this script in a non-production environment is recommended before deploying it in a production environment.
