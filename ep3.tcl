#Create a simulator object
set ns [new Simulator]

#Define colors for different data flows
$ns color 1 Blue 
$ns color 2 Red

#set TCP variant & queuing discipline from commandline
set variant [lindex $argv 0]
set queue [lindex $argv 1]

#Open the NAM trace file   
set nf [open out.nam w]
$ns namtrace-all $nf

#Open the Trace file 
set tf [open ep3_${variant}_${queue}.trace w]
$ns trace-all $tf

#"finish" proc
proc finish {} {
	#global declaration 
	global ns nf tf
	#write the trace to out.nam
	$ns flush-trace
	#close the NAM trace file
	close $nf
	#close the Trace file
	close $tf
	#Execute NAM on the trace file
	#exec nam out.nam &
	exit 0	
}

#Create 6 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#crete links for the nodes
if {$queue eq "DropTail"} {
	$ns duplex-link $n0 $n1 10Mb 10ms DropTail
	$ns duplex-link $n4 $n1 10Mb 10ms DropTail
	$ns duplex-link $n1 $n2 10Mb 10ms DropTail
	$ns duplex-link $n3 $n2 10Mb 10ms DropTail
	$ns duplex-link $n5 $n2 10Mb 10ms DropTail
} elseif {$queue eq "RED"} {
	$ns duplex-link $n0 $n1 10Mb 10ms RED
	$ns duplex-link $n4 $n1 10Mb 10ms RED
	$ns duplex-link $n1 $n2 10Mb 10ms RED
	$ns duplex-link $n3 $n2 10Mb 10ms RED
	$ns duplex-link $n5 $n2 10Mb 10ms RED
}

#set queue size
$ns queue-limit $n0 $n1 10
$ns queue-limit $n4 $n1 10
$ns queue-limit $n1 $n2 10
$ns queue-limit $n3 $n2 10
$ns queue-limit $n5 $n2 10

#define position 
$ns duplex-link-op $n0 $n1 orient right-down
$ns duplex-link-op $n4 $n1 orient right-up
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n2 $n3 orient right-up
$ns duplex-link-op $n2 $n5 orient right-down

#create UDP client at n4
set udp [new Agent/UDP]
$ns attach-agent $n4 $udp

#create UDP sink at n5, "NULL" agent just frees the packets received
set null [new Agent/Null]
$ns attach-agent $n5 $null

#create the datalink from n1 to n2 with Red color
$ns connect $udp $null
$udp set fid_ 2

#attach CBR to UDP at n4
set cbr [new Application/Traffic/CBR]
$cbr set rate_ 7mb
$cbr set type_ CBR
$cbr attach-agent $udp

#set a TCP
if {$variant == "Reno"} {
	set tcp [new Agent/TCP/Reno]
	set sink [new Agent/TCPSink]
} elseif {$variant == "SACK"} {
	set tcp [new Agent/TCP/Sack1]
	set sink [new Agent/TCPSink/Sack1]
} 

#attach tcp at n0
$ns attach-agent $n0 $tcp
#set Vegas parameter, in this configuration Vegas tries to keep between 1 and 3 packet queueed in the network
#if {$variant == "Vegas"} {
#	$tcp set v_alpha_ 1
#	$tcp set v_beta_ 3
#}
#set color Blue
$tcp set fid_ 1
$ns attach-agent $n3 $sink

#link n0 and n3
$ns connect $tcp $sink

#setup a FTP application
set ftp [new Application/FTP]
$ftp attach-agent $tcp

#setup begining and ending time 
$ns at 0 "$ftp start"
$ns at 2 "$cbr start"
$ns at 6 "$cbr stop"
$ns at 8 "$ftp stop"

#call the finish proc
$ns at 10 "finish"
#print CBR packet size and interval
#puts "CBR packets size = [$cbr set packet_size_]"
#puts "CBR interval = [$cbr set interval_]"

#run the simualtion 
$ns run
