#Create a simulator object
set ns [new Simulator]

#Define colors for different data flows
$ns color 1 Blue 
$ns color 2 Red
$ns color 3 Green

#set TCP variant & CBR rate from commandline
set variant0 [lindex $argv 0]
set variant1 [lindex $argv 1]
set cbrrate [lindex $argv 2]

#Open the NAM trace file   
set nf [open out.nam w]
$ns namtrace-all $nf

#Open the Trace file 
set tf [open ep2_${variant0}_${variant1}_${cbrrate}.trace w]
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
$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n4 $n1 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail
$ns duplex-link $n3 $n2 10Mb 10ms DropTail
$ns duplex-link $n5 $n2 10Mb 10ms DropTail

#define position 
$ns duplex-link-op $n0 $n1 orient right-down
$ns duplex-link-op $n4 $n1 orient right-up
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n2 $n3 orient right-up
$ns duplex-link-op $n2 $n5 orient right-down

#create UDP client at n1
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

#create UDP sink at n2, "NULL" agent just frees the packets received
set null [new Agent/Null]
$ns attach-agent $n2 $null

#create the datalink from n1 to n2 with Red color
$ns connect $udp $null
$udp set fid_ 2

#attach CBR to UDP at n1
set cbr [new Application/Traffic/CBR]
$cbr set rate_ ${cbrrate}mb
$cbr set type_ CBR
$cbr attach-agent $udp

#set first TCP
if {$variant0 == "Tahoe"} {
	set tcp0 [new Agent/TCP]
} elseif {$variant0 == "Reno"} {
	set tcp0 [new Agent/TCP/Reno]
} elseif {$variant0 == "NewReno"} {
	set tcp0 [new Agent/TCP/Newreno]
} elseif {$variant0 == "Vegas"} {
	set tcp0 [new Agent/TCP/Vegas]
}

#attach tcp at n0
$ns attach-agent $n0 $tcp0
#set Vegas parameter, in this configuration Vegas tries to keep between 1 and 3 packet queueed in the network
if {$variant0 == "Vegas"} {
	$tcp0 set v_alpha_ 1
	$tcp0 set v_beta_ 3
}
#set color Blue
$tcp0 set fid_ 1

#create TCP sink at n3
set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0

#link n0 and n3
$ns connect $tcp0 $sink0

#setup a FTP application
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

#set second TCP
if {$variant1 == "Tahoe"} {
	set tcp1 [new Agent/TCP]
} elseif {$variant1 == "Reno"} {
	set tcp1 [new Agent/TCP/Reno]
} elseif {$variant1 == "NewReno"} {
	set tcp1 [new Agent/TCP/Newreno]
} elseif {$variant1 == "Vegas"} {
	set tcp1 [new Agent/TCP/Vegas]
}

#attach tcp at n4
$ns attach-agent $n4 $tcp1
#set Vegas parameter, in this configuration Vegas tries to keep between 1 and 3 packet queueed in the network
if {$variant1 == "Vegas"} {
	$tcp1 set v_alpha_ 1
	$tcp1 set v_beta_ 3
}
#set color Green
$tcp1 set fid_ 3

#create TCP sink at n5
set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1

#link n4 and n5
$ns connect $tcp1 $sink1

#setup a FTP application
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

#setup begining and ending time 
$ns at 0 "$cbr start"
$ns at 2 "$ftp0 start"
$ns at 2 "$ftp1 start"
$ns at 6 "$ftp0 stop"
$ns at 6 "$ftp1 stop"
$ns at 8 "$cbr stop"

#call the finish proc
$ns at 10 "finish"
#print CBR packet size and interval
#puts "CBR packets size = [$cbr set packet_size_]"
#puts "CBR interval = [$cbr set interval_]"

#run the simualtion 
$ns run
