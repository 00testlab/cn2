set ns [new Simulator]

set fin [open result.tr w]
$ns trace-all $fin

set nfin [open namtrace.nam w]
$ns namtrace-all $nfin

set cwind [open win.tr w]
$ns rtproto DV

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 0.3Mb 10ms DropTail
$ns duplex-link $n2 $n0 0.3Mb 10ms DropTail
$ns duplex-link $n1 $n4 0.3Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.3Mb 10ms DropTail
$ns duplex-link $n3 $n5 0.3Mb 10ms DropTail
$ns duplex-link $n4 $n5 0.3Mb 10ms DropTail

$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n4 orient right
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n4 $n5 orient right-down
$ns duplex-link-op $n3 $n5 orient right-up

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set tcp1 [new Agent/TCPSink]
$ns attach-agent $n4 $tcp1

$ns connect $tcp0 $tcp1

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$ns rtmodel-at 1.0 down $n1 $n4
$ns rtmodel-at 3.0 up $n1 $n4

proc PlotWindow {tcpSource file} {
global ns
set counter 0.01
set currenttime [$ns now]
set cwind [$tcpSource set cwnd_]
puts $file "$currenttime $cwind"
$ns at [expr $currenttime + $counter] "PlotWindow $tcpSource $file"
}
$ns at 0.5 "PlotWindow $tcp0 $cwind"

proc finish {} {
global ns fin nfin
$ns flush-trace
close $fin
close $nfin
exec nam namtrace.nam &
exec xgraph win.tr & 
exit 0
}



$ns at 0.2 "$ftp0 start"
$ns at 4.0 "$ftp0 stop"
$ns at 5.0 "finish"
$ns run
