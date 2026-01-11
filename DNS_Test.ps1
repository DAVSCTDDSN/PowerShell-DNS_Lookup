# Clear the Screen
Clear-Host

#Initialize the Variables
$Result = @()
$RecordResult = @()

# List DNS Servers you want to query
$DnsServers = "8.8.4.4", "8.8.8.8", "1.1.1.1"

# List the DNS Records you want to query
$DnsRecords = "nbcdfw.com", "msn.com", "www.msn.com", "cbs11.com", "104.69.125.254", "myfakednsrecord.com", "142.250.114.100", "204.79.197.219"

#Run the Query
foreach ($Server in $DnsServers) {
    foreach ($Record in $DnsRecords){
       try {
        $Result = ""
        $Result =  resolve-dnsname $Record -Server $Server -DnsOnly -ErrorAction Stop
            $DetailedResult = New-Object System.Object
            $DetailedResult | Add-Member -NotePropertyName "Record_Name" -NotePropertyValue $Record
            $DetailedResult | Add-Member -NotePropertyName "Type" -NotePropertyValue $Result.QueryType
            if ($Result.QueryType -eq "PTR"){$DetailedResult | Add-Member -NotePropertyName "Data" -NotePropertyValue $Result.NameHost
            } elseif ($Result.QueryType -eq "CNAME") {$DetailedResult | Add-Member -NotePropertyName "Data" -NotePropertyValue $Result.NameHost
            } else{$DetailedResult | Add-Member -NotePropertyName "Data" -NotePropertyValue $Result.IPAddress
            }
            $DetailedResult | Add-Member -NotePropertyName "DNS_Server" -NotePropertyValue $Server
            $DetailedResult | Add-Member -NotePropertyName "Note" -NotePropertyValue "Lookup was Successful"
        $RecordResult += $DetailedResult
       }
       catch {
        $FailedResult = New-Object System.Object
            $FailedResult   | Add-Member -NotePropertyName "Record_Name" -NotePropertyValue $Record
            $FailedResult   | Add-Member -NotePropertyName "Type" -NotePropertyValue "."
            $FailedResult | Add-Member -NotePropertyName "Data" -NotePropertyValue "."
            $FailedResult | Add-Member -NotePropertyName "DNS_Server" -NotePropertyValue $Server
            $FailedResult | Add-Member -NotePropertyName "Note" -NotePropertyValue "Lookup Failed"
       $RecordResult += $FailedResult
       }
        

    }
}

#Colorize the Data
$coloredData = $RecordResult | ForEach-Object {
    $RecordName = $_.Record_Name
    $Type = $_.Type
    $Data = $_.Data
    $Note = $_.Note

    if ($Note -eq "Lookup Failed") {
        # Embed Red color code
        $_.Record_Name = "$($PSStyle.Foreground.Red)$RecordName$($PSStyle.Reset)"
        $_.Type = "$($PSStyle.Foreground.Red)$Type$($PSStyle.Reset)"
        $_.Data = "$($PSStyle.Foreground.Red)$Data$($PSStyle.Reset)"
        $_.Note = "$($PSStyle.Foreground.Red)$Note$($PSStyle.Reset)"
    } else {

    }
    $_
}

# Format the output as a table
$coloredData | Format-Table -AutoSize
# $coloredData | ConvertTo-HTML -property "Record_Name", "Type", "Data", "DNS_Server", "Note"