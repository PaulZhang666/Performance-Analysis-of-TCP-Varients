# Performance-Analysis-of-TCP-Varients
CS_5700 project_3 analysis performance of different TCPs （TCP Tahoe, Reno, NewReno, Vegas, SACK）  

Use NS-2 network simulator to perform experiments that will help to analyze the behavior of TCP variants

                         N1                      N4
                           \                    /
                            \                  /
                             N2--------------N3
                            /                  \
                           /                    \
                         N5                      N6

Experiment 1: TCP Performance Under Congestion
Analyze the performance of TCP variants (Tahoe, Reno, NewReno, and Vegas) under the influence of various load conditions.
Add a CBR source at N2 and a sink at N3, then add a single TCP stream from N1 to a sink at N4. Analyze the throughput, packet drop rate, and latency of the TCP stream as a function of the bandwidth used by the CBR flow. 

Experiemnt 2: Fairness Between TCP Variants
Start three flows: one CBR, and two TCP. Add a CBR source at N2 and a sink at N3, then add two TCP streams from N1 to N4 and N5 to N6, respectively. As in Experiment 1, plot the average throughput, packet loss rate, and latency of each TCP flow as a function of the bandwidth used by the CBR flow. Repeat the experiments using the following pairs of TCP variants (i.e. with one flow from N1 to N4, and the other flow from N5 to N6):

Reno/Reno
NewReno/Reno
Vegas/Vegas
NewReno/Vegas

Experiment 3: Influence of Queuing
Queuing disciplines like DropTail and Random Early Drop (RED) are algorithms that control how packets in a queue are treated. In these experiments, instead of varying the rate of the CBR flow, you will study the influence of the queuing discipline used by nodes on the overall throughput of flows.
Use the same topology from experiment 1 and have one TCP flow (N1-N4) and one CBR/UDP (N5-N6) flow. First, start the TCP flow. Once the TCP flow is steady, start the CBR source and analyze how the TCP and CBR flows change under the following queuing algorithms: DropTail and RED. Perform the experiments with TCP Reno and SACK.

