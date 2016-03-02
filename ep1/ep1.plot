set terminal png
set termoption enhanced
set grid 

#plot throughput 
set output "pic/ep1_throughput.png"
set title "Experiment 1: Throughput"
set xlabel "CBR (Mbps)"
set ylabel "Throughput (Mbps)"
set xrange[5:10]
set yrange[0:]
#linestyle, linetype, linewidth, linecolor, pointtype, pointsize
plot 'data1/ep1_throughput.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "Tahoe", \
 'data1/ep1_throughput.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Reno", \
 'data1/ep1_throughput.dat' using 1:4 with linespoints pointtype 12 linecolor 5 title "NewReno", \
 'data1/ep1_throughput.dat' using 1:5 with linespoints pointtype 15 linecolor 1 title "Vegas"
unset output

#plot droprate 
set output "pic/ep1_droprate.png"
set title "Experiment 1: Droprate"
set xlabel "CBR (Mbps)"
set ylabel "Droprate (%)"
set xrange[5:10]
set yrange[0:]
#linestyle, linetype, linewidth, linecolor, pointtype, pointsize
plot 'data1/ep1_drop_rate.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "Tahoe", \
 'data1/ep1_drop_rate.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Reno", \
 'data1/ep1_drop_rate.dat' using 1:4 with linespoints pointtype 12 linecolor 5 title "NewReno", \
 'data1/ep1_drop_rate.dat' using 1:5 with linespoints pointtype 15 linecolor 1 title "Vegas"
unset output

#plot latnecy
set output "pic/ep1_latency.png"
set title "Experiment 1: Latency"
set xlabel "CBR (Mbps)"
set ylabel "Latency (ms)"
set xrange[5:10]
set yrange[0:]
#linestyle, linetype, linewidth, linecolor, pointtype, pointsize
plot 'data1/ep1_latency.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "Tahoe", \
 'data1/ep1_latency.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Reno", \
 'data1/ep1_latency.dat' using 1:4 with linespoints pointtype 12 linecolor 5 title "NewReno", \
 'data1/ep1_latency.dat' using 1:5 with linespoints pointtype 15 linecolor 1 title "Vegas"
unset output