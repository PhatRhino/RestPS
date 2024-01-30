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
