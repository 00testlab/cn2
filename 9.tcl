#Setting the default parameters

set val(chan)	Channel/WirelessChannel
set val(prop)	Propagation/TwoRayGround
set val(netif)	Phy/WirelessPhy
set val(mac)	Mac/802_11
set val(ifq)	CMUPriQueue
set val(ll)	LL
set val(ant)	Antenna/OmniAntenna
set val(x)	700
set val(y)	700
set val(ifqlen)	50
set val(nn)	6
set val(stop)	60.0
set val(rp)	DSR

set ns [new Simulator]
set traceid [open 004.tr w]
$ns trace-all $traceid

set namtrace [open 004.nam w]
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

set prop [new $val(prop)]

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

#Node Configuration
$ns node-config -adhocRouting	$val(rp)\
		-llType		$val(ll)\
		-macType	$val(mac)\
		-ifqType	$val(ifq)\
		-ifqLen		$val(ifqlen)\
		-antType	$val(ant)\
		-propType	$val(prop)\
		-phyType	$val(netif)\
		-channelType 	$val(chan)\
		-topoInstance	$topo\
		-agentTrace	ON\
		-routerTrace	ON\
		-macTrace	ON\

#Creating Nodes
for {set i 0} {$i < $val(nn)} {incr i} {
set node_($i) [$ns node]
$node_($i) random-motion 0
}

$node_(0) set X_ 150
$node_(0) set Y_ 300
$node_(0) set Z_ 0

$node_(1) set X_ 300
$node_(1) set Y_ 500
$node_(1) set Z_ 0

$node_(2) set X_ 500
$node_(2) set Y_ 500
$node_(2) set Z_ 0

$node_(3) set X_ 300
$node_(3) set Y_ 100
$node_(3) set Z_ 0

$node_(4) set X_ 500
$node_(4) set Y_ 100
$node_(4) set Z_ 0

$node_(5) set X_ 650
$node_(5) set Y_ 300
$node_(5) set Z_ 0

#initial position of nodes
for {set i 0} {$i < $val(nn)} {incr i} {
$ns initial_node_pos $node_($i) 40
}

#topology design

$ns at 1.0 "$node_(0) setdest 150.0 300.0 2.0"
$ns at 1.0 "$node_(1) setdest 300.0 500.0 2.0"
$ns at 1.0 "$node_(2) setdest 500.0 500.0 2.0"
$ns at 1.0 "$node_(3) setdest 300.0 100.0 2.0"
$ns at 1.0 "$node_(4) setdest 500.0 100.0 2.0"
$ns at 1.0 "$node_(5) setdest 650.0 300.0 2.0"

$ns at 4.0 "$node_(3) setdest 300.0 500.0 100.0"

#Generatng Traffic
set tcp0 [new Agent/TCP]
set sink0 [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp0
$ns attach-agent $node_(5) $sink0
$ns connect $tcp0 $sink0
set ftp [new Application/FTP]
$ftp attach-agent $tcp0
$ns at 3.0 "$ftp start"
$ns at 60.0 "$ftp stop"

exec nam 004.nam &

#Simulation Termination 
for {set i 0} {$i < $val(nn)} {incr i} {
$ns at $val(stop) "$node_($i) reset";
}

$ns at $val(stop) "puts \"NS EXITING..\"; $ns halt"
puts "Starting Simulation..."
$ns run

