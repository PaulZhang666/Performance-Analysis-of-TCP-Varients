import sys
import os
import time

#Define tcp variants and CBR_Rate
TCP_VARIANT = ['Tahoe','Reno','NewReno','Vegas']
CBR_RATE = ['1','1.5','2','2.5','3','3.5','4','4.5','5','5.5','6','6.5','7','7.5','8','8.5','9','9.5','10']

def getThroughput(tcpkind, cbr_rate):
	tracefile = 'ep1_' + tcpkind + '_' + cbr_rate +'.trace'
	tcp_start = 2.0
	tcp_end = 6.0

	totalBytesReceived = 0

	with open (tracefile) as f:
		for line in f:
			sec = line.split()
			event = sec[0]
			time = float(sec[1])
			from_node = sec[2]
			to_node = sec[3]
			pkttype = sec[4]
			pktsize = int(sec[5])
			flow_id = sec[7]
			src_addr = sec[8]
			dst_addr = sec[9]
			seq_num = sec[10]

			if flow_id == '1' and event =='r' and to_node == '3':
			#count the tcp packets from n2 to n3
				totalBytesReceived += pktsize
				#renew the tcp_end time from send to receive
				tcp_end = time
	return totalBytesReceived * 8 / (tcp_end - tcp_start) / 1000000
	#Mbps

def getDropRate(tcpkind, cbr_rate):
	tracefile = 'ep1_' + tcpkind + '_' + cbr_rate +'.trace'
	totalPacketSent = 0
	totalPacketReceived = 0

	with open (tracefile) as f:
		for line in f:
			sec = line.split()
			event = sec[0]
			time = float(sec[1])
			from_node = sec[2]
			to_node = sec[3]
			pkttype = sec[4]
			pktsize = int(sec[5])
			flow_id = sec[7]
			src_addr = sec[8]
			dst_addr = sec[9]
			seq_num = sec[10]
			if flow_id == '1':
				if event == '-' and from_node == '0':
					totalPacketSent += 1
				if event == 'r' and to_node == '0' and pkttype == 'ack':
					totalPacketReceived += 1
	if totalPacketSent == 0:
		return 0
	else:
		return float (totalPacketSent - totalPacketReceived) / totalPacketSent * 100

def getDelay(tcpkind, cbr_rate):
	tracefile = 'ep1_' + tcpkind + '_' + cbr_rate +'.trace'
	tcp_start = 2.0
	tcp_end = 6.0

	send_time = {}
	ack_time = {}

	total_latency = 0.0
	total_packet = 0

	with open (tracefile) as f:
		for line in f:
			sec = line.split()
			event = sec[0]
			time = float(sec[1])
			from_node = sec[2]
			to_node = sec[3]
			pkttype = sec[4]
			pktsize = int(sec[5])
			flow_id = sec[7]
			src_addr = sec[8]
			dst_addr = sec[9]
			seq_num = sec[10]
			if flow_id == '1':
				if event == '-' and from_node == '0':
				#get the send time and save in send_time{}
					send_time.update({seq_num:time})
				
				if event == 'r' and to_node == '0' and pkttype == 'ack':
				#get the ack time and save in ack_time{}
					ack_time.update({seq_num:time})	
				

	#get the seq_num set of packet acked
	acked_seq_num = {k for k in send_time.viewkeys() if k in ack_time.viewkeys()}

	for seq in acked_seq_num:
		latency = ack_time[seq] - send_time[seq]
		if latency > 0:
			total_latency += latency
			total_packet += 1
	if total_packet == 0:
		print 'No packet acked'
		return 0
	else:
		#average latency in ms
		return total_latency / total_packet * 1000

def main():
	num_test = 0

	#run all the test
	for tcpkind in TCP_VARIANT:
		for cbr_rate in CBR_RATE:
			os.system('ns ep1.tcl ' + tcpkind + ' ' + cbr_rate)
			num_test += 1
			# sleep a little while for previous simulation to completion
			time.sleep(3)
			print tcpkind,
			print '@',
			print cbr_rate,
			print 'Mbps',
			print 'finished'

	f1 = open('ep1_throughput.dat', 'w')
	#get the throughput result
	for tcpkind in TCP_VARIANT:
		throughput = ''
		for cbr_rate in CBR_RATE:
			throughput = throughput + '\t' + str(getThroughput(tcpkind, cbr_rate))
		f1.write(str(tcpkind) + throughput + '\n')
	f1.close()

	f2 = open('ep1_drop_rate.dat', 'w')
	#get the droprate result
	for tcpkind in TCP_VARIANT:
		droprate = ''
		for cbr_rate in CBR_RATE:
			droprate = droprate + '\t' + str(getDropRate(tcpkind, cbr_rate))
		f2.write(str(tcpkind) + droprate + '\n')
	f2.close()

	f3 = open('ep1_latency.dat', 'w')
	#get the latency result
	for tcpkind in TCP_VARIANT:
		latency = ''
		for cbr_rate in CBR_RATE:
			latency = latency + '\t' + str(getDelay(tcpkind, cbr_rate))
		f3.write(str(tcpkind) + latency + '\n')
	f3.close()

	os.system("mkdir data")
	os.system("mv *.dat ./data")
	
if __name__ == '__main__':
	main()






