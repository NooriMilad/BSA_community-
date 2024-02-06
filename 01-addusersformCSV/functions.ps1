# Function to add AD Users from a CSV file
function Add-Users {
    param (
        [Parameter(Mandatory = $true)]
        [string]$csvPath
    )

    # Existing code for checking CSV file existence
    # ...

    # Import CSV data
    $userData = Import-Csv -Path $csvPath


    function Add-Ou { #
        param (
            [string]$ouName,
            [string]$ouPath
        )

        # Check if the OU already exists
        if (-not (Get-ADOrganizationalUnit -Filter { Name -eq $ouName })) {
            # Create the OU
            New-ADOrganizationalUnit -Name $ouName -Path $ouPath -ProtectedFromAccidentalDeletion $false
        } else {
            Write-Host "OU '$ouName' already exists."
        }
    }

    function Add-Groups {
        param (
            [string]$groupName,
            [string]$groupPath
        )

        # Check if the group already exists
        if (-not (Get-ADGroup -Filter { Name -eq $groupName })) {
            # Create the group
            New-ADGroup -Name $groupName -GroupScope DomainLocal -GroupCategory Security -Path $groupPath
        } else {
            Write-Host "Group $groupName already exists."
        }

        # Add benutze auf group
        Add-ADGroupMember -Identity $groupName -Members $username
    }

   
}

# Main script
param (
    [Parameter(Mandatory = $true)]
    [string]$csvPath
)

# rufen die  Add-Users function
Add-Users -csvPath $csvPath
 
Write-Host "Alles fertig."


Read-Host "Press enter to continue."
