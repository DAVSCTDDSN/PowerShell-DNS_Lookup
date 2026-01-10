# Clear the Screen
Clear-Host

#Initialize the Variables
$Result = @()
$RecordResult = @()

# List DNS Servers you want to query
$DnsServers = "8.8.4.4", "8.8.8.8", "1.1.1.1"

# List the DNS Records you want to query
$DnsRecords = "nbcdfw.com", "msn.com", "cbs11.com", "104.69.125.254", "myfakednsrecord.com"

#Run the Query
foreach ($Server in $DnsServers) {
    foreach ($Record in $DnsRecords){
       try {
        $Result = ""
        $Result =  resolve-dnsname $Record -Server $Server -DnsOnly -ErrorAction Stop
            $DetailedResult = New-Object System.Object
            $DetailedResult | Add-Member -NotePropertyName "Record_Name" -NotePropertyValue $Record
            $DetailedResult | Add-Member -NotePropertyName "Type" -NotePropertyValue $Result.QueryType
            $DetailedResult | Add-Member -NotePropertyName "IP_Address" -NotePropertyValue $Result.IPAddress
            $DetailedResult | Add-Member -NotePropertyName "DNS_Server" -NotePropertyValue $Server
            $DetailedResult | Add-Member -NotePropertyName "Note" -NotePropertyValue "Lookup was Succesful"
        $RecordResult += $DetailedResult
       }
       catch {
        $FailedResult = New-Object System.Object
            $FailedResult   | Add-Member -NotePropertyName "Record_Name" -NotePropertyValue $Record
            $FailedResult   | Add-Member -NotePropertyName "Type" -NotePropertyValue "."
            $FailedResult | Add-Member -NotePropertyName "IP_Address" -NotePropertyValue "."
            $FailedResult | Add-Member -NotePropertyName "DNS_Server" -NotePropertyValue $Server
            $FailedResult | Add-Member -NotePropertyName "Note" -NotePropertyValue "Lookup Failed"
       $RecordResult += $FailedResult
       }
        

    }
}
$RecordResult | Format-Table -AutoSize