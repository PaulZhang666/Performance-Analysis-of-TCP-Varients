set terminal png
set termoption enhanced
set grid 

#plot throughput 1
set output "pic/ep3_throughput_Reno.png"
set title "Experiment 3: Throughput with Reno"
set xlabel "Time (s)"
set ylabel "Throughput (Mbps)"
#set xrange[5:10]
#set yrange[0:]
#linestyle, linetype, linewidth, linecolor, pointtype, pointsize
plot 'data/ep3_Reno_DropTail_throughput.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "DropTail-TCP", \
 'data/ep3_Reno_RED_throughput.dat' using 1:2 with linespoints pointtype 4 linecolor 15 title "RED-TCP", \
 'data/ep3_Reno_DropTail_throughput.dat' using 1:3 with linespoints pointtype 12 linecolor 5 title "DropTail-CBR", \
 'data/ep3_Reno_RED_throughput.dat' using 1:3 with linespoints pointtype 15 linecolor 1 title "RED-CBR"
unset output

#plot throughput 2
set output "pic/ep3_throughput_SACK.png"
set title "Experiment 3: Throughput with SACK"
set xlabel "Time (s)"
set ylabel "Throughput (Mbps)"
#set xrange[5:10]
#set yrange[0:]
#linestyle, linetype, linewidth, linecolor, pointtype, pointsize
plot 'data/ep3_SACK_DropTail_throughput.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "DropTail-TCP", \
 'data/ep3_SACK_RED_throughput.dat' using 1:2 with linespoints pointtype 4 linecolor 15 title "RED-TCP", \
 'data/ep3_SACK_DropTail_throughput.dat' using 1:3 with linespoints pointtype 12 linecolor 5 title "DropTail-CBR", \
 'data/ep3_SACK_RED_throughput.dat' using 1:3 with linespoints pointtype 15 linecolor 1 title "RED-CBR"
unset output

#plot latnecy
set output "pic/ep3_latency.png"
set title "Experiment 3: Latency"
set xlabel "Time (s)"
set ylabel "Latency (ms)"
#set xrange[5:10]
#set yrange[0:]
#linestyle, linetype, linewidth, linecolor, pointtype, pointsize
plot 'data/ep3_Reno_DropTail_latency.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "Reno-DropTail", \
 'data/ep3_Reno_RED_latency.dat' using 1:2 with linespoints pointtype 4 linecolor 15 title "Reno-RED", \
 'data/ep3_SACK_DropTail_latency.dat' using 1:2 with linespoints pointtype 12 linecolor 5 title "SACK-DropTail", \
 'data/ep3_SACK_RED_latency.dat' using 1:2 with linespoints pointtype 15 linecolor 1 title "SACK-RED"
unset output