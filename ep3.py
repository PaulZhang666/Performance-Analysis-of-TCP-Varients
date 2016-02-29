import sys
import os
import time

#Define tcp variants and CBR_Rate
TCP_VARIANT = ['Reno','SACK']
QUE_VARIANT = ['RED', 'DropTail']

def getThroughput(tcpkind, queue_kind, step):
	tracefile = 'ep3_' + tcpkind + '_' + queue_kind +'.trace'
	datafile = 'ep3_' + tcpkind + '_' + queue_kind +'_throughput.dat'
	f3 = open(datafile, 'w')

	timestamp = 0.0
	totalBytesReceived_0 = 0
	totalBytesReceived_1 = 0

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

			if flow_id == '1' and event == 'r' and to_node == '3':
			#count the tcp packets from n2 to n3
				totalBytesReceived_0 += pktsize
			if flow_id == '2' and event == 'r' and to_node == '5':
				totalBytesReceived_1 += pktsize

			if time - timestamp <= step:
				pass
			else:
				throughput_0 = float(totalBytesReceived_0) * 8 / step / 1000000
				throughput_1 = float(totalBytesReceived_1) * 8 / step / 1000000
				f3.write(str(timestamp) + '\t' + str(throughput_0) + '\t' + str(throughput_1) + '\n')
				timestamp += step
				totalBytesReceived_0 = 0
				totalBytesReceived_1 = 0
		f3.close
	return 0
'''
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
'''
def getDelay(tcpkind, queue_kind, step):
	tracefile = 'ep3_' + tcpkind + '_' + queue_kind +'.trace'
	datafile = 'ep3_' + tcpkind + '_' + queue_kind + '_latency.dat'
	f3 = open(datafile, 'w')

	send_time = {}
	ack_time = {}

	timestamp = 0.0

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
				
			if time - timestamp <= step:
				pass
			else:
				acked_seq_num = {k for k in send_time.viewkeys() if k in ack_time.viewkeys()}

				for seq in acked_seq_num:
					latency = ack_time[seq] - send_time[seq]
					if latency > 0:
						total_latency += latency
						total_packet += 1
				if total_packet == 0:
					total_latency =0
				else:
					total_latency = total_latency / total_packet * 1000
				f3.write(str(timestamp) + '\t' + str(total_latency) + '\n')
				
				timestamp += step
				#reset
				total_latency = 0
				send_time = {}
				ack_time = {}
				total_packet = 0
		f3.close

def main():
	num_test = 0

	#run all the test
	for tcpkind in TCP_VARIANT:
		for queue in QUE_VARIANT:
			os.system('ns ep3.tcl ' + tcpkind + ' ' + queue)
			num_test += 1
			# sleep a little while for previous simulation to completion
			time.sleep(3)
			print tcpkind,
			print '@',
			print queue,
			print 'finished'

	#get the throughput result
	for tcpkind in TCP_VARIANT:
		for queue in QUE_VARIANT:
			getThroughput(tcpkind, queue, 1)
	for tcpkind in TCP_VARIANT:
		for queue in QUE_VARIANT:
			getDelay(tcpkind, queue, 1)
	
	os.system("mkdir data")
	os.system("mv *.dat ./data")	

if __name__ == '__main__':
	main()






