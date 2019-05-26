#Create Simulator Object
set ns [new Simulator]

#File Operations
set fin [open result.tr w]
$ns trace-all $fin

set nfin [open namtrace.nam w]
$ns namtrace-all $nfin

#Create Nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#Create Links Between Nodes
$ns duplex-link $n0 $n2 5.5Mb 5ms DropTail
$ns duplex-link $n1 $n2 5.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 5.5Mb 5ms DropTail

#Set Queue Limit
$ns queue-limit $n0 $n2 5
$ns queue-limit $n1 $n2 5
$ns queue-limit $n2 $n3 5

#Create,Attach Agents(Protocols)
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set tcp1 [new Agent/TCPSink]
$ns attach-agent $n3 $tcp1

set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0
set udp1 [new Agent/Null]
$ns attach-agent $n3 $udp1

#Connect Protocols
$ns connect $tcp0 $tcp1
$ns connect $udp0 $udp1

#Create,Attach Applications
set ftp [new Application/FTP]
$ftp attach-agent $tcp0
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp0

#Create Events
$ns at 0.2 "$ftp start"
$ns at 0.2 "$cbr start"

$ns at 2.0 "$ftp stop"
$ns at 2.0 "$cbr stop"

#Finish Procedure
proc finish {} {
global ns fin nfin
$ns flush-trace
close $nfin
close $fin
exec nam namtrace.nam
exit 0
}
#Finish
$ns at 5.0 "finish"
$ns run