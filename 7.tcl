#Setting the Default Parameters

set val(chan)	Channel/WirelessChannel
set val(prop)	Propagation/TwoRayGround
set val(netif)	Phy/WirelessPhy
set val(mac)	Mac/802_11
set val(ifq)	Queue/DropTail/PriQueue
set val(ll)	LL
set val(ant)	Antenna/OmniAntenna
set val(x)	500
set val(y)	500
set val(ifqlen)	50
set val(nn)	3
set val(stop)	30.0
#use AODV , DSDV and DSR
set val(rp)	AODV						

set ns [new Simulator]
set tracefd [open 002.tr w]
$ns trace-all $tracefd

set namtrace [open 002.nam w]
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
		-channelType	$val(chan)\
		-topoInstance	$topo\
		-agentTrace	ON\
		-routerTrace	ON\
		-macTrace	ON\


#Creating Nodes
for {set i 0} {$i < $val(nn) } {incr i} {
set node_($i) [$ns node]
$node_($i) random-motion 0
}

#Initial Positions of Nodes

for {set i 0} {$i < $val(nn)} {incr i} {
$ns initial_node_pos $node_($i) 40
}


#Topology Design
$ns at 0.0 "$node_(0) setdest 450.0 285.0 30.0"
$ns at 0.0 "$node_(1) setdest 200.0 285.0 30.0"
$ns at 0.0 "$node_(2) setdest 1.0 285.0 30.0"
$ns at 12.5 "$node_(0) setdest 300.0 285.0 10.0"
$ns at 12.5 "$node_(2) setdest 100.0 285.0 10.0"
$ns at 20.0 "$node_(0) setdest 490.0 285.0 5.0"
$ns at 20.0 "$node_(2) setdest 1.0 285.0 5.0"


#Generating Traffic
set tcp0 [new Agent/TCP]
set sink0 [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp0
$ns attach-agent $node_(2) $sink0
$ns connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 3.0 "$ftp0 start"
$ns at 30.0 "$ftp0 stop"


#Simulation Termination
for {set i 0} {$i < $val(nn) } {incr i} {
$ns at $val(stop) "$node_($i) reset";
}

exec nam 002.nam &

$ns at $val(stop) "puts \"NS EXITING...\" ; $ns halt"
puts "Starting Simulation..."
$ns run
