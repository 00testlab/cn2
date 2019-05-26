set ns [new Simulator]

set tf [open tf.tr w]
$ns trace-all $tf

set nf [open nf.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]

$n0 label "Server"
$n1 label "Client"

$ns duplex-link $n0 $n1 0.2Mb 5ms DropTail

#$ns duplex-link-op $n0 $n1 orient right

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set tcp1 [new Agent/TCPSink]
$ns attach-agent $n1 $tcp1

set ftp [new Application/FTP]
$ftp attach-agent $tcp0

$ns connect $tcp0 $tcp1

#$ns color 1 red
$tcp0 set fid_ 1

$tcp0 set packetsize_ 1500

proc finish {} {
global ns tf nf
$ns flush-trace
close $tf
close $nf
exec nam nf.nam &
exec awk -f graph.awk tf.tr > graph.tr
exec xgraph graph.tr -t "Bytes Recieved By Client" -x "Time(sec)" -y "Number of Bytes"
exit 0
}

$ns at 0.2 "$ftp start"

$ns at 5.0 "$ftp stop"
$ns at 5.2 "finish"
$ns run

