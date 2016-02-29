import sys
import os
import time

#Define tcp variants and CBR_Rate
TCP_VARIANT_0 = ['Reno', 'NewReno', 'Vegas']
TCP_VARIANT_1 = ['Reno', 'Vegas']
CBR_RATE = ['1','1.5','2','2.5','3','3.5','4','4.5','5','5.5','6','6.5','7','7.5','8','8.5','9','9.5','10']

#try
#TCP_VARIANT_0 = ['Reno']
#TCP_VARIANT_1 = ['Reno']
#CBR_RATE = ['6']

def getThroughput(tcpkind, cbr_rate):
	tracefile = 'ep2_' + tcpkind + '_' + cbr_rate +'.trace'
	tcp_start = 2.0
	tcp_end_0 = 6.0
	tcp_end_1 = 6.0

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

			if flow_id == '1' and event =='r' and to_node == '3':
			#count the tcp packets from n2 to n3
				totalBytesReceived_0 += pktsize
				#renew the tcp_end time from send to receive
				tcp_end_0 = time
			if flow_id == '3' and event =='r' and to_node == '5':
			#count the tcp packets from n2 to n5
				totalBytesReceived_1 += pktsize
				#renew the tcp_end time from send to receive
				tcp_end_1 = time

		throughput_0 = totalBytesReceived_0 * 8 / (tcp_end_0 - tcp_start) / 1000000
		throughput_1 = totalBytesReceived_1 * 8 / (tcp_end_1 - tcp_start) / 1000000
		#Mbps
		return str(throughput_0) + '\t' + str(throughput_1)

def getDropRate(tcpkind, cbr_rate):
	tracefile = 'ep2_' + tcpkind + '_' + cbr_rate +'.trace'
	totalPacketSent_0 = 0
	totalPacketSent_1 = 0
	totalPacketReceived_0 = 0
	totalPacketReceived_1 = 0

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
					totalPacketSent_0 += 1
				if event == 'r' and to_node == '0' and pkttype == 'ack':
					totalPacketReceived_0 += 1

			if flow_id == '3':
				if event == '-' and from_node == '4':
					totalPacketSent_1 += 1
				if event == 'r' and to_node == '4' and pkttype == 'ack':
					totalPacketReceived_1 += 1
	if totalPacketSent_0 == 0:
		droprate_0 = 0
	else:
		droprate_0 = float (totalPacketSent_0 - totalPacketReceived_0) / totalPacketSent_0 * 100

	if totalPacketSent_1 == 0:
		droprate_1 = 0
	else:
		droprate_1 = float (totalPacketSent_1 - totalPacketReceived_1) / totalPacketSent_1 * 100

	return str(droprate_0) + '\t' + str(droprate_1)

def getDelay(tcpkind, cbr_rate):
	tracefile = 'ep2_' + tcpkind + '_' + cbr_rate +'.trace'
	tcp_start = 2.0
	tcp_end = 6.0

	send_time_0 = {}
	send_time_1 = {}
	ack_time_0 = {}
	ack_time_1 = {}

	total_latency_0 = 0.0
	total_latency_1 = 0.0
	total_packet_0 = 0
	total_packet_1 = 0

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
					send_time_0.update({seq_num:time})
				
				if event == 'r' and to_node == '0' and pkttype == 'ack':
				#get the ack time and save in ack_time{}
					ack_time_0.update({seq_num:time})	
				
			if flow_id == '3':
				if event == '-' and from_node == '4':
				#get the send time and save in send_time{}
					send_time_1.update({seq_num:time})
				
				if event == 'r' and to_node == '4' and pkttype == 'ack':
				#get the ack time and save in ack_time{}
					ack_time_1.update({seq_num:time})	

	#get the seq_num set of packet acked
	acked_seq_num = {k for k in send_time_0.viewkeys() if k in ack_time_0.viewkeys()}

	for seq in acked_seq_num:
		latency = ack_time_0[seq] - send_time_0[seq]
		if latency > 0:
			total_latency_0 += latency
			total_packet_0 += 1
	if total_packet_0 == 0:
		print 'No packet acked'
		latency_0 = 0
	else:
		#average latency in ms
		latency_0 = total_latency_0 / total_packet_0 * 1000

	acked_seq_num = {k for k in send_time_1.viewkeys() if k in ack_time_1.viewkeys()}

	for seq in acked_seq_num:
		latency = ack_time_1[seq] - send_time_1[seq]
		if latency > 0:
			total_latency_1 += latency
			total_packet_1 += 1
	if total_packet_1 == 0:
		print 'No packet acked'
		latency_1 = 0
	else:
		#average latency in ms
		latency_1 = total_latency_1 / total_packet_1 * 1000

	return str(latency_0) + '\t' + str(latency_1)

def main():
	num_test = 0

	#make 4 kinds of experiments variants
	variants = []
	for var0 in TCP_VARIANT_0:
		for var1 in TCP_VARIANT_1:
			if var0 == 'Reno' and var1 =='Vegas':
				continue
			if var0 == 'Vegas' and var1 == 'Reno':
				continue
			else:
				variants.append(var0 + ' ' + var1)


	#run all the test
	for tcpkind in variants:
		for cbr_rate in CBR_RATE:
			os.system('ns ep2.tcl ' + tcpkind + ' ' + cbr_rate)
			num_test += 1
			# sleep a little while for previous simulation to completion
			time.sleep(3)
			print tcpkind,
			print '@',
			print cbr_rate,
			print 'Mbps',
			print 'finished'

	#get throughput file name list
	throughput_list = []
	for tcpkind in variants:
		temp = tcpkind.split()
		throughput_list.append('ep2_' + temp[0] + '_' + temp[1] + '_' + 'throughput.dat')

	for throughput_file in throughput_list:
	#get the throughput result
		f1 = open(throughput_file, 'w')
		temp = throughput_file.split('_')
		tcp_kind = temp[1] + '_' + temp[2]
		throughput = ''
		for cbr_rate in CBR_RATE:
			f1.write(str(cbr_rate) + '\t' + getThroughput(tcp_kind, cbr_rate) + '\n')
		f1.close	

	#get droprate file name list
	drop_list = []	
	for tcpkind in variants:
		temp = tcpkind.split()
		drop_list.append('ep2_' + temp[0] + '_' + temp[1] + '_' + 'droprate.dat')
	
	for drop_file in drop_list:
	#get the droprate result
		f2 = open(drop_file, 'w')
		temp = drop_file.split('_')
		tcp_kind = temp[1] + '_' + temp[2]
		droprate = ''
		for cbr_rate in CBR_RATE:
			f2.write(str(cbr_rate) + '\t' + getDropRate(tcp_kind, cbr_rate) + '\n')
		f2.close()

	#get latency file name list
	latency_list = []
	for tcpkind in variants:
		temp = tcpkind.split()
		latency_list.append('ep2_' + temp[0] + '_' + temp[1] + '_' + 'latency.dat')

	for latency_file in latency_list:
	#get the latency result
		f3 = open(latency_file, 'w')
		temp = latency_file.split('_')
		tcp_kind = temp[1] + '_' + temp[2]
		latency = ''
		for cbr_rate in CBR_RATE:
			f3.write(str(cbr_rate) + '\t' + getDelay(tcp_kind, cbr_rate) + '\n')
		f3.close()

	os.system("mkdir data")
	os.system("mv *.dat ./data")

if __name__ == '__main__':
	main()






