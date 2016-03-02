set terminal png
set termoption enhanced
set grid

#plot throughput 1 
set output "pic/ep2_Reno_Reno_throughput.png"
set title "Experiment 2: Reno-Reno Throughput"
set xlabel "CBR (Mbps)"
set ylabel "Throughput (Mbps)"
set xrange[5:10]
set yrange[0:]
plot 'data/ep2_Reno_Reno_throughput.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "Reno N1-N4", \
 'data/ep2_Reno_Reno_throughput.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Reno N5-N6"
unset output

#plot throughput 2 
set output "pic/ep2_NewReno_Reno_throughput.png"
set title "Experiment 2: NewReno-Reno Throughput"
set xlabel "CBR (Mbps)"
set ylabel "Throughput (Mbps)"
set xrange[5:10]
set yrange[0:]
plot 'data/ep2_NewReno_Reno_throughput.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "NewReno N1-N4", \
 'data/ep2_NewReno_Reno_throughput.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Reno N5-N6"
unset output

#plot throughput 3 
set output "pic/ep2_NewReno_Vegas_throughput.png"
set title "Experiment 2: NewReno-Vegas Throughput"
set xlabel "CBR (Mbps)"
set ylabel "Throughput (Mbps)"
set xrange[5:10]
set yrange[0:]
plot 'data/ep2_NewReno_Vegas_throughput.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "NewReno N1-N4", \
 'data/ep2_NewReno_Vegas_throughput.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Vegas N5-N6"
unset output

#plot throughput 4
set output "pic/ep2_Vegas_Vegas_throughput.png"
set title "Experiment 2: Vegas-Vegas Throughput"
set xlabel "CBR (Mbps)"
set ylabel "Throughput (Mbps)"
set xrange[5:10]
set yrange[0:]
plot 'data/ep2_Vegas_Vegas_throughput.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "Vegas N1-N4", \
 'data/ep2_Vegas_Vegas_throughput.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Vegas N5-N6"
unset output

#plot droprate 1 
set output "pic/ep2_Reno_Reno_droprate.png"
set title "Experiment 2: Reno-Reno Droprate"
set xlabel "CBR (Mbps)"
set ylabel "Droprate (%)"
set xrange[5:10]
set yrange[0:]
plot 'data/ep2_Reno_Reno_droprate.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "Reno N1-N4", \
 'data/ep2_Reno_Reno_droprate.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Reno N5-N6"
unset output

#plot droprate 2 
set output "pic/ep2_NewReno_Reno_droprate.png"
set title "Experiment 2: NewReno-Reno Droprate"
set xlabel "CBR (Mbps)"
set ylabel "Droprate (%)"
set xrange[5:10]
set yrange[0:]
plot 'data/ep2_NewReno_Reno_droprate.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "NewReno N1-N4", \
 'data/ep2_NewReno_Reno_droprate.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Reno N5-N6"
unset output

#plot droprate 3 
set output "pic/ep2_NewReno_Vegas_droprate.png"
set title "Experiment 2: NewReno-Vegas Droprate"
set xlabel "CBR (Mbps)"
set ylabel "Droprate (%)"
set xrange[5:10]
set yrange[0:]
plot 'data/ep2_NewReno_Vegas_droprate.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "NewReno N1-N4", \
 'data/ep2_NewReno_Vegas_droprate.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Vegas N5-N6"
unset output

#plot droprate 4 
set output "pic/ep2_Vegas_Vegas_droprate.png"
set title "Experiment 2: Vegas-Vegas Droprate"
set xlabel "CBR (Mbps)"
set ylabel "Droprate (%)"
set xrange[5:10]
set yrange[0:]
plot 'data/ep2_Vegas_Vegas_droprate.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "Vegas N1-N4", \
 'data/ep2_NewReno_Reno_droprate.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Vegas N5-N6"
unset output

#plot latency 1 
set output "pic/ep2_Reno_Reno_Latency.png"
set title "Experiment 2: Reno-Reno Latency"
set xlabel "CBR (Mbps)"
set ylabel "Latency (ms)"
set xrange[5:10]
set yrange[0:]
plot 'data/ep2_Reno_Reno_latency.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "Reno N1-N4", \
 'data/ep2_Reno_Reno_latency.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Reno N5-N6"
unset output

#plot latency 2 
set output "pic/ep2_NewReno_Reno_Latency.png"
set title "Experiment 2: MewReno-Reno Latency"
set xlabel "CBR (Mbps)"
set ylabel "Latency (ms)"
set xrange[5:10]
set yrange[0:]
plot 'data/ep2_NewReno_Reno_latency.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "NewReno N1-N4", \
 'data/ep2_NewReno_Reno_latency.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Reno N5-N6"
unset output

#plot latency 3 
set output "pic/ep2_NewReno_Vegas_Latency.png"
set title "Experiment 2: NewReno-Vegas Latency"
set xlabel "CBR (Mbps)"
set ylabel "Latency (ms)"
set xrange[5:10]
set yrange[0:]
plot 'data/ep2_NewReno_Vegas_latency.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "NewReno N1-N4", \
 'data/ep2_NewReno_Vegas_latency.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Vegas N5-N6"
unset output

#plot latency 4 
set output "pic/ep2_Vegas_Vegas_Latency.png"
set title "Experiment 2: Vegas-Vegas Latency"
set xlabel "CBR (Mbps)"
set ylabel "Latency (ms)"
set xrange[5:10]
set yrange[0:]
plot 'data/ep2_Vegas_Vegas_latency.dat' using 1:2 with linespoints pointtype 1 linecolor 18 title "Vegas N1-N4", \
 'data/ep2_Vegas_Vegas_latency.dat' using 1:3 with linespoints pointtype 4 linecolor 15 title "Vegas N5-N6"
unset output