#!/bin/ruby
#
# This sample demonstrates how to get/set device propety.
#

require 'socket'

require '../ptp.rb'
require '../ptp_ip.rb'

ADDR = "192.168.1.1"
PORT = 15740

NAME = "GetObject"
GUID = "ab653fb8-4add-44f0-980e-939b5f6ea266"
PROTOCOL_VERSION = 65536

MTU = 1200

def str2guid(str)
    hexes = str.scan /([a-fA-F0-9]{2})-*/
    hexes.flatten!
    raise "Invalid GUID" if hexes.length != 16
    hexes.map do |s|
        s.hex
    end
end

def write_packet(sock, pkt)
    sock.send(pkt.to_data.pack("C*"), 0)
end

def read_packet(sock)
    data = []
    data += sock.read(PTPIP_packet::MIN_PACKET_SIZE).unpack("C*")
    len = PTPIP_packet.parse_length(data)
    data += sock.read(len-PTPIP_packet::MIN_PACKET_SIZE).unpack("C*")
    PTPIP_packet.new(data)
end

def recv_data(sock, transaction_id)
    recv_pkt = read_packet(sock)
    raise "Invalid Packet : #{recv_pkt.to_s}" if recv_pkt.type != PTPIP_PT_StartDataPacket
    raise "Invalid Transaction ID" if recv_pkt.payload.transaction_id != transaction_id
    data_len = recv_pkt.payload.total_data_length_low
    data = []
    while recv_pkt.type != PTPIP_PT_EndDataPacket
        recv_pkt = read_packet(sock)
        raise "Invalid Packet : #{recv_pkt.to_s}" if recv_pkt.type != PTPIP_PT_DataPacket && recv_pkt.type != PTPIP_PT_EndDataPacket
        raise "Invalid Transaction ID" if recv_pkt.payload.transaction_id != transaction_id
        data += recv_pkt.payload.data_payload
    end
    raise "Invalid Data Size" unless data_len == data.length
    return data
end

def send_packet(sock, packet)
    sock.send(packet.to_data.pack("C*"), 0)
end

def send_data(sock, transaction_id, data)

    s = 0
      
    #start data phase
    payload = PTPIP_payload_START_DATA_PKT.new()
    payload.transaction_id = transaction_id
    payload.total_data_length_low = data.size
    payload.total_data_length_high = 0
   
    packet = PTPIP_packet.create(payload)
  
    if 0 > send_packet(sock, packet) then raise "send error." end
  
    ##data
    while s+MTU < data.size do
        payload = PTPIP_payload_DATA_PKT.new()
        payload.transaction_id = transaction_id
        payload.data_payload = data[s..s+MTU-1]
    
        packet = PTPIP_packet.create(payload)
    
        if 0 > send_packet(sock, packet) then raise "send error." end
    
        s += MTU
    end
  
    ##end data
    payload = PTPIP_payload_END_DATA_PKT.new()
    payload.transaction_id = transaction_id
    payload.data_payload = data[s..-1]
  
    packet = PTPIP_packet.create(payload)
  
    if 0 > send_packet(sock, packet) then raise "send error." end
end

def init_command(sock)
    init_command_payload = PTPIP_payload_INIT_CMD_PKT.new()
    init_command_payload.guid = str2guid(GUID)
    init_command_payload.friendly_name = NAME
    init_command_payload.protocol_version = PROTOCOL_VERSION 
    init_command = PTPIP_packet.create(init_command_payload)

    write_packet(sock, init_command)
    read_packet(sock)#ACK
end

def init_event(sock, conn_number)
    init_event_payload = PTPIP_payload_INIT_EVENT_REQ_PKT.new()
    init_event_payload.conn_number = @conn_number
    init_event = PTPIP_packet.create(init_event_payload);
    
    write_packet(sock, init_event)
    read_packet(sock)
end

def data_operation(sock, operation_code, transaction_id, parameters = [])
    op_payload = PTPIP_payload_OPERATION_REQ_PKT.new()
    op_payload.data_phase_info = PTPIP_payload_OPERATION_REQ_PKT::NO_DATA_OR_DATA_IN_PHASE
    op_payload.operation_code = operation_code
    op_payload.transaction_id = transaction_id
    op_payload.parameters = parameters
    op_pkt = PTPIP_packet.create(op_payload)
    write_packet(sock, op_pkt)

    data = recv_data(sock, transaction_id)
    recv_pkt = read_packet(sock)
    return recv_pkt, data
end

def simple_operation(sock, operation_code, transaction_id, parameters = [], data = nil)
    op_payload = PTPIP_payload_OPERATION_REQ_PKT.new()
    op_payload.data_phase_info = PTPIP_payload_OPERATION_REQ_PKT::NO_DATA_OR_DATA_IN_PHASE
    op_payload.operation_code = operation_code
    op_payload.transaction_id = transaction_id
    op_payload.parameters = parameters
    op_pkt = PTPIP_packet.create(op_payload)
    write_packet(sock, op_pkt)

    send_data(sock, transaction_id, data) if data

    read_packet(sock)
end

TCPSocket.open(ADDR, PORT) do |s|

    recv_pkt = init_command(s)
    raise "Initialization Failed (Command) #{recv_pkt.payload.reason}" if recv_pkt.type == PTPIP_PT_InitFailPacket
    p @conn_number = recv_pkt.payload.conn_number
    p @guid = recv_pkt.payload.guid
    p @name = recv_pkt.payload.friendly_name
    p @protocol_version = recv_pkt.payload.protocol_version

    TCPSocket.open(ADDR, PORT) do |es|

        recv_pkt = init_event(es, @conn_number)
        raise "Initialization Failed (Event) #{recv_pkt.payload.reason}" if recv_pkt.type == PTPIP_PT_InitFailPacket
        print "Command/Event Connections are established.\n"
        
        @transaction_id = 1
        @session_id = 1

        recv_pkt = simple_operation(s, PTP_OC_OpenSession, @transaction_id, [@session_id])
        raise "Open Session Failed #{recv_pkt.payload.response_code}" if recv_pkt.payload.response_code != PTP_RC_OK
        @transaction_id += 1

        recv_pkt, data = data_operation(s, PTP_OC_GetDevicePropValue, @transaction_id, [PTP_DPC_WiteBalance])
        raise "GetDevicePropValue Failed #{recv_pkt.payload.response_code}" if recv_pkt.payload.response_code != PTP_RC_OK
        original_white_balance = data.pack('C*').unpack('S')[0]
        print "Original White Balance: #{original_white_balance.to_s}\n"
        @transaction_id += 1

        set_white_balance_data = [PTP_WB_Daylight].pack('S').unpack('C*')
        recv_pkt = simple_operation(s, PTP_OC_SetDevicePropValue, @transaction_id, [PTP_DPC_WiteBalance], set_white_balance_data)
        raise "PTP_OC_SetDevicePropValue Failed #{recv_pkt.payload.response_code}" if recv_pkt.payload.response_code != PTP_RC_OK
        print "Set White Balance: #{set_white_balance_data.to_s}\n"
        @transaction_id += 1

        recv_pkt, data = data_operation(s, PTP_OC_GetDevicePropValue, @transaction_id, [PTP_DPC_WiteBalance])
        raise "GetDevicePropValue Failed #{recv_pkt.payload.response_code}" if recv_pkt.payload.response_code != PTP_RC_OK
        white_balance = data.pack('C*').unpack('S')[0]
        print "White Balance: #{white_balance.to_s}\n"
        @transaction_id += 1

        set_original_white_balance_data = [original_white_balance].pack('S').unpack('C*')
        recv_pkt = simple_operation(s, PTP_OC_SetDevicePropValue, @transaction_id, [PTP_DPC_WiteBalance], set_original_white_balance_data)
        raise "PTP_OC_SetDevicePropValue Failed #{recv_pkt.payload.response_code}" if recv_pkt.payload.response_code != PTP_RC_OK
        @transaction_id += 1

        recv_pkt = simple_operation(s, PTP_OC_CloseSession, @transaction_id) 
        raise "Close Session Failed #{recv_pkt.payload.response_code}" if recv_pkt.payload.response_code != PTP_RC_OK
        @transaction_id += 1

    end

end
