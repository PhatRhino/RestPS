#TODO: Update Functionality for Single IPs and Network CIDR Notations
function Get-RestIPAuth
{
    $RestIPAuth = @{
        UserIP = @(
                @{
                    IP = '192.168.22.18'
                },
                @{
                    IP = "192.168.22.5"
                }
            )
        }
    $RestIPAuth
}
function Test-IPAddress {
    param (
        [Parameter(Mandatory = $true)]
        [string]$IPAddress
    )

    # Predefined list of IP addresses and CIDR notations (x.x.x.x or x.x.x.x/x)
    $IPList = @(
        "192.168.1.1",      # Individual IP
        "192.168.10.1/32",   # CIDR notation
        "10.0.0.5",         # Individual IP
        "172.16.0.1/33"     # CIDR notation
        # Add more IP addresses or CIDR notations as needed
    )

    # Function to check if the IP falls within a CIDR range
    function Test-IPInCIDR {
        param (
            [string]$IP,
            [string]$CIDR
        )

        $parts = $CIDR -split '/'
        $baseIP = $parts[0]
        $subnetSize = [int]$parts[1]
        $subnetMask = -bnot ([Math]::Pow(2, (32 - $subnetSize)) - 1)

        $ipBytes = [System.Net.IPAddress]::Parse($IP).GetAddressBytes()
        [Array]::Reverse($ipBytes)
        $ipToCheck = [System.BitConverter]::ToUInt32($ipBytes, 0)

        $baseBytes = [System.Net.IPAddress]::Parse($baseIP).GetAddressBytes()
        [Array]::Reverse($baseBytes)
        $base = [System.BitConverter]::ToUInt32($baseBytes, 0)

        return ($ipToCheck -band $subnetMask) -eq ($base -band $subnetMask)
    }

    # Check each item in the list
    foreach ($item in $IPList) {
        if ($item -like "*/*") {
            # Handle CIDR notation
            if (Test-IPInCIDR -IP $IPAddress -CIDR $item) {
                return $true
            }
        } elseif ($item -eq $IPAddress) {
            # Exact match for an IP address
            return $true
        }
    }

    # If no match found
    return $false
}

# Example usage
$IPToCheck = "192.168.10.1"
if (Test-IPAddress -IPAddress $IPToCheck) {
    Write-Host "$IPToCheck is within the defined range."
} else {
    Write-Host "$IPToCheck is not within the defined range."
}
