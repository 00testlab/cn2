set ns [new Simulator]

set tl2 [open l2.tr w]
$ns trace-all $tl2

set nl2 [open l2.nam w]
$ns namtrace-all $nl2

set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns duplex-link $n1 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n3 $n4 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n6 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n5 1.5Mb 5ms DropTail

$ns duplex-link-op $n3 $n1 orient left-up
$ns duplex-link-op $n3 $n2 orient left-down
$ns duplex-link-op $n4 $n5 orient right-up
$ns duplex-link-op $n4 $n6 orient right-down
$ns duplex-link-op $n3 $n4 orient right

set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0

set tcp1 [new Agent/TCPSink]
$ns attach-agent $n6 $tcp1

set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2

set tcp3 [new Agent/TCPSink]
$ns attach-agent $n5 $tcp3

$ns connect $tcp0 $tcp1

$ns connect $tcp2 $tcp3

set ftp [new Application/FTP]

$ftp attach-agent $tcp0

set telnet [new Application/Telnet]

$telnet attach-agent $tcp2

set cl2ftp [open cl2ftp.tr w]
proc PlotWindow {tcpSource f} {
global ns
 set counter 0.01
 set currenttime [$ns now]
 set cwnd [$tcpSource set cwnd_]
 puts $f "$currenttime $cwnd"
 $ns at [expr $currenttime+$counter] "PlotWindow $tcpSource $f"
}

set cl2tel [open cl2tel.tr w]
proc PlotWindow {tcpSource f} {
 global ns
 set counter 0.01
 set currenttime [$ns now]
 set cwnd [$tcpSource set cwnd_]
 puts $f "$currenttime $cwnd"
 $ns at [expr $currenttime+$counter] "PlotWindow $tcpSource $f"
}


$ns at 0.2 "$ftp start"
$ns at 2.0 "$ftp stop"

$ns at 0.2 "$telnet start"
$ns at 2.0 "$telnet stop"

$ns at 0.2 "PlotWindow $tcp0 $cl2ftp"

$ns at 0.2 "PlotWindow $tcp2 $cl2tel"

proc finish {} {
 global ns tl2 nl2
 $ns flush-trace
 close $tl2
 close $nl2
 exec nam l2.nam &
 exec xgraph cl2tel.tr &
 exec xgraph cl2ftp.tr &
 exit 0
}
$ns at 2.5 "finish"

$ns run
