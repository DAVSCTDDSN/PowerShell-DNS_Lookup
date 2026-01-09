# Clear the Screen
cls

# List DNS Servers you want to query
$DnsServers = "8.8.4.4", "8.8.8.8", "1.1.1.1"

# List the DNS Records you want to query
$DnsRecords = "yahoo.com", "msn.com", "google.com"

#Run the Query
foreach ($Server in $DnsServers) {
    foreach ($Record in $DnsRecords){
        $Result =  resolve-dnsname $Record
    }
    $Results += $Result
}