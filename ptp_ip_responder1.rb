#!/opt/local/bin/ruby

require 'socket'
require 'find'

require 'ptp.rb'
require 'ptp_ip.rb'


#######################################
MTU = 1200

#######################################
class RubyPTPDeviceInfo < PTP_DeviceInfo
    def initialize()
        super
        @standard_varsion = 100
        @vender_extension_id = 0
        @vender_extension_version = 0
        @vender_extention_desc = ""
        @functional_mode = PTP_FM_StandardMode
        @operations_supported = [#Pull minimize
            PTP_OC_GetDeviceInfo,
            PTP_OC_OpenSession,
            PTP_OC_CloseSession,
            PTP_OC_GetStorageIDs,
            PTP_OC_GetStorageInfo,
            PTP_OC_GetNumObjects,
            PTP_OC_GetObjectHandles,
            PTP_OC_GetObjectInfo,
            PTP_OC_GetObject,
            PTP_OC_GetThumb,
        ]
        @events_supported = [
            PTP_EC_Undefined,
            PTP_EC_CancelTransaction,
            PTP_EC_ObjectAdded,
            PTP_EC_ObjectRemoved,
            PTP_EC_StoreAdded,
            PTP_EC_StoreRemoved,
            PTP_EC_DevicePropChanged,
            PTP_EC_ObjectInfoChanged,
            PTP_EC_DeviceInfoChanged,
            PTP_EC_RequestObjectTransfer,
            PTP_EC_StoreFull,
            PTP_EC_DeviceReset,
            PTP_EC_StorageInfoChanged,
            PTP_EC_CaptureComplete,
            PTP_EC_UnreportedStatus,
        ]
        @device_properties_supported = [
        ]
        @capture_formats = [
        ]
        @image_formats = [
            PTP_OFC_Association,
            PTP_OFC_Text,
            PTP_OFC_EXIF_JPEG,
            PTP_OFC_JFIF,
            PTP_OFC_TIFF,
        ]
        @manufacturer = ""#"ReijiTokuda" #
        @model = ""#"RB-100PTP"
        @device_version = "1.00"
        @serial_number = "aaaa"
    end
end

class StrageInfo1 < PTP_StorageInfo
    def initialize()
        @storage_type = PTP_ST_RemovableRAM
        @filesystem_type = PTP_FT_GenericFlat
        @access_capability = PTP_AC_ReadOnly
        @max_capability_low = 0xFFFFFFFF
        @max_capability_high = 0xFFFFFFFF
        @free_space_in_bytes_low = 10 * 1024 * 1024
        @free_space_in_bytes_high = 0
        @free_space_in_images = 100
        @storage_description = "Virtual Flash"
        @volume_label = "D"
    end
end

class Object_1217024680302 < PTP_ObjectInfo
    def initialize()
        @storage_id = 0x00010001
        @object_format = PTP_OFC_JFIF
        @protection_status = PTP_PS_NoProtection #S
        @object_compressed_size = 86098
        @thumb_format = PTP_OFC_TIFF
        @thumb_compressed_size = 80600
        @thumb_pix_width = 160
        @thumb_pix_height = 120
        @image_pix_width = 560
        @image_pix_height = 700
        @image_bit_depth = 0
        @parent_object = 0
        @association_type = 0
        @association_desc = 0
        @sequence_number = 0
        @filename = "1217024680302.jpg"
        @capture_date = "20080726T182200"
        @modification_date = ""
        @keywords = ""#'_' separeted
    end
end

#######################################

OBJECTS1 = [
    {:object_info => Object_1217024680302.new(), :object_handle => 1},
]

STORAGE = [
    {
    :storage_id => 0x00010001,
    :path => "./storage1",
    :storage_info => StrageInfo1.new(),
    :objects => OBJECTS1,
    },
]

def create_storage_ids
    storage_ids = []
    STORAGE.each do |s|
        storage_ids << s[:storage_id]
    end
    return storage_ids
end

def storage_ids2data(storage_ids)
    raise "invalid type" if not storage_ids.is_a?(Array)
    [storage_ids.size].pack("L*").unpack("C*")+
    storage_ids.pack("L*").unpack("C*")
end

def get_storage_info(storage_id)
    ret = STORAGE.select do |s|
        s[:storage_id] == storage_id
    end
    return ret[0][:storage_info]
end


def init_objects
end

def get_object_handles(storage_id)
    ret = STORAGE.select do |s|
        s[:storage_id] == storage_id
    end
    ret = ret[0][:objects].map do |o|
        o[:object_handle]
    end
end

def get_object_handles_data(object_handles)
    raise "invalid data" if not object_handles.is_a? Array
    [object_handles.size].pack("L").unpack("C*")+
    object_handles.pack("L*").unpack("C*")
end

def get_object_info(object_handle)
    STORAGE.each do |s|
    
        ret = s[:objects].each do |h|
            return h[:object_info] if h[:object_handle] == object_handle
        end
    end
    return nil
end

#######################################

class Connection
    
    @@max_connection_number = 0
    @@command_connections = {}
    @@event_connections = {}
    
    #class methods
    
    def self.create_connection(sock)
        ### first packet
        bin = sock.recv(1024)
        data = bin.unpack("C*")
        dump_read_data(data)
                            
        packet = PTPIP_packet.new(data)
        p packet    #dump
        
        conn = nil
        
        if packet.type == 1 then
            conn = Connection.create_command_connection(sock, packet)
        elsif packet.type == 3 then
            conn = Connection.create_event_connection(sock, packet)
        else
            raise "Invalid First Packet : "+packet
        end

        raise "Invalid Connection" if not conn
                
        return conn
    end
    
    def self.create_command_connection(sock, packet)
        raise "Invalid Packet : "+packet if not packet.type == 1
        @@max_connection_number += 1
        @@command_connections[@@max_connection_number] = 
            CommandConnection.new(sock, packet, @@max_connection_number)
    end
    
    def self.create_event_connection(sock, packet)
        raise "Invalid Packet : "+packet if not packet.type == 3
        if not @@event_connections[packet.payload.conn_number] then
            if @@command_connections[packet.payload.conn_number] then
                @@event_connections[packet.payload.conn_number] = 
                    EventConnection.new(sock, packet)
            end
        end
    end
    
    def self.delete_command_connection(connection_number)
        @@command_connections.delete(connection_number)
        raise "event connection is running" if @@event_connections[connection_number]
    end
    
    def self.delete_event_connection(connection_number)
        @@event_connections.delete(connection_number)
    end
    
end


#######################################



class CommandConnection < Connection


    def initialize(sock, packet, connection_number)
        @sock = sock
        @first_packet = packet
        @connection_number = connection_number
        
        print "Command : " #dump
        p @first_packet #dump
    end
    
    def get_packet
        bin = @sock.recv(1024)
        raise "command socket closed" if bin == nil or bin == ""
        data = bin.unpack("C*")
        dump_read_data(data)
                            
        packet = PTPIP_packet.new(data)
        print "Command : "  #dump
        p packet.to_hash    #dump
        
        return packet
    end
    
    def send_packet(packet)
        dump_write_data(packet.to_data) #dump
        @sock.send(packet.to_data.pack("C*"), 0)
    end
    
    def send_data_sequence(transaction_id, data)
    
        s = 0
            
        #start data phase
        payload = PTPIP_payload_START_DATA_PKT.new()
        payload.transaction_id = transaction_id
        payload.total_data_length_low = data.size
        payload.total_data_length_high = 0
        
        packet = PTPIP_packet.create(payload)
        
        if 0 > send_packet(packet) then raise "send error." end
        
        ##data
        while s+MTU < data.size do
            payload = PTPIP_payload_DATA_PKT.new()
            payload.transaction_id = transaction_id
            payload.data_payload = data[s..s+MTU-1]
            
            packet = PTPIP_packet.create(payload)
            
            if 0 > send_packet(packet) then raise "send error." end
            
            s += MTU
        end
        
        ##end data
        payload = PTPIP_payload_END_DATA_PKT.new()
        payload.transaction_id = transaction_id
        payload.data_payload = data[s..-1]
        
        packet = PTPIP_packet.create(payload)
        
        if 0 > send_packet(packet) then raise "send error." end
    end
    
    def send_response_code(transaction_id, code, parameters)
    
        payload = PTPIP_payload_OPERATION_RES_PKT.new()
        payload.response_code = code
        payload.transaction_id = transaction_id
        payload.parameters = parameters
        
        packet = PTPIP_packet.create(payload)
        
        if 0 > send_packet(packet) then raise "send error." end
    end
    
    RESPONDER_GUID = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
    RESPONDER_FRIENDLY_NAME = "Ruby-PTP-Responder"
    RESPONDER_PROTOCOL_VERSION = 65536
    
    def send_init_cmd_ack_pkt
        
        payload = PTPIP_payload_INIT_CMD_ACK.new()
        payload.conn_number = @connection_number
        payload.guid = RESPONDER_GUID
        payload.friendly_name = RESPONDER_FRIENDLY_NAME
        payload.protocol_version = RESPONDER_PROTOCOL_VERSION
        
        packet = PTPIP_packet.create(payload)
        
        print "Command : " #dump
        p packet.to_hash#dump #dump
        
        if 0 > send_packet(packet) then raise "send error." end
    end
    
    def send_device_info_pkt
    
        device_info = RubyPTPDeviceInfo.new()
        device_info_data = device_info.to_data
        
        send_data_sequence(0, device_info_data)# get device info shall set to 0
        
        send_response_code(0, PTP_RC_OK, []) # get device info shall set to 0
    end
    
    def send_open_session_response_pkt()
        send_response_code(0, PTP_RC_OK, []) # open session shall set to 0
    end
    
    def send_storage_ids(transaction_id, storage_ids)
    
        storage_ids_data = storage_ids2data(storage_ids)
        
        send_data_sequence(transaction_id, storage_ids_data)
        
        send_response_code(transaction_id, PTP_RC_OK, [])
    end
    
    def send_storage_info(transaction_id, storage_id)
        
        storage_info = get_storage_info(storage_id)
        storage_info_data = storage_info.to_data
        
        send_data_sequence(transaction_id, storage_info_data)
        
        send_response_code(transaction_id, PTP_RC_OK, [])
    end
    
    def send_object_handles(transaction_id, object_handles)
        
        object_handles_data = get_object_handles_data(object_handles)
            
        send_data_sequence(transaction_id, object_handles_data)
        
        send_response_code(transaction_id, PTP_RC_OK, [])
    end
    
    def send_object_info(transaction_id, object_info)
    
        object_info_data = object_info.to_data
        
        send_data_sequence(transaction_id, object_info_data)
        
        send_response_code(transaction_id, PTP_RC_OK, [])
    end
    
    #########
    def start
    
        #command ack
        send_init_cmd_ack_pkt
        print "init command ack is sent\n"
        
        #next
        packet = get_packet
        raise "invlaid sequence" if not packet.type == 6
        raise "invalid sequence" if not packet.payload.transaction_id == 0
        raise "invalid sequence" if not packet.payload.data_phase_info ==
                PTPIP_payload_OPERATION_REQ_PKT::NO_DATA_OR_DATA_IN_PHASE
        raise "invalid sequence" if not packet.payload.operation_code == 
                PTP_OC_GetDeviceInfo
        
        #device info
        send_device_info_pkt
        print "device info is sent\n"
        
        
        #next
        packet = get_packet
        raise "invlaid sequence" if not packet.type == 6
        raise "invalid sequence" if not packet.payload.transaction_id == 0
        raise "invalid sequence" if not packet.payload.data_phase_info ==
                PTPIP_payload_OPERATION_REQ_PKT::NO_DATA_OR_DATA_IN_PHASE
        raise "invalid sequence" if not packet.payload.operation_code == 
                PTP_OC_OpenSession
        raise "invalid sequence" if not packet.payload.parameters.size == 1
        raise "invalid parameter" if packet.payload.parameters[0] == 0
        raise "invalid sequence" if not packet.payload.parameters[0] == 1
        
        #store session ID
        @session_id = packet.payload.parameters[0]
        raise "invalid session ID" if @session_id != @connection_number
        
        #create object handles #ココで作るのが推奨
        init_objects
        
        #create storage ids #ココで作るのが推奨
        storage_ids = create_storage_ids
        
        #response
        send_open_session_response_pkt
        print "response is sent(open session)\n"
        
        
        #next
        packet = get_packet
        raise "invlaid sequence" if not packet.type == 6
        raise "invalid sequence" if not packet.payload.transaction_id == 1
        raise "invalid sequence" if not packet.payload.data_phase_info ==
                PTPIP_payload_OPERATION_REQ_PKT::NO_DATA_OR_DATA_IN_PHASE
        raise "invalid sequence" if not packet.payload.operation_code == 
                PTP_OC_GetStorageIDs
        
        #response
        send_storage_ids(packet.payload.transaction_id, storage_ids)
        print "response is sent(storage ids)\n"
        
        
        #next
        packet = get_packet
        raise "invlaid sequence" if not packet.type == 6
        raise "invalid sequence" if not packet.payload.transaction_id == 2
        raise "invalid sequence" if not packet.payload.data_phase_info ==
                PTPIP_payload_OPERATION_REQ_PKT::NO_DATA_OR_DATA_IN_PHASE
        raise "invalid sequence" if not packet.payload.operation_code == 
                PTP_OC_GetStorageInfo
        raise "invalid sequence" if not packet.payload.parameters.size == 1
        raise "invalid sequence" if not packet.payload.parameters[0] == 65537
        
        #response
        send_storage_info(packet.payload.transaction_id,
                            packet.payload.parameters[0])
        print "response is sent(storage info 1)\n"
        
        #next
        packet = get_packet
        raise "invlaid sequence" if not packet.type == 6
        raise "invalid sequence" if not packet.payload.transaction_id == 3
        raise "invalid sequence" if not packet.payload.data_phase_info ==
                PTPIP_payload_OPERATION_REQ_PKT::NO_DATA_OR_DATA_IN_PHASE
        raise "invalid sequence" if not packet.payload.operation_code == 
                PTP_OC_GetObjectHandles
        raise "invalid sequence" if not packet.payload.parameters.size == 3
        raise "invalid sequence" if not packet.payload.parameters[0] == 65537
        raise "invalid sequence" if not packet.payload.parameters[1] == 0#object format code
        raise "invalid sequence" if not packet.payload.parameters[2] == 0#association
        
        object_handles = get_object_handles(packet.payload.parameters[0])
        
        #response
        send_object_handles(packet.payload.transaction_id,
                            object_handles)
        print "response is sent(object handles 1)\n"
        
        #next
        packet = get_packet
        raise "invlaid sequence" if not packet.type == 6
        raise "invalid sequence" if not packet.payload.transaction_id == 4
        raise "invalid sequence" if not packet.payload.data_phase_info ==
                PTPIP_payload_OPERATION_REQ_PKT::NO_DATA_OR_DATA_IN_PHASE
        raise "invalid sequence" if not packet.payload.operation_code == 
                PTP_OC_GetObjectInfo
        raise "invalid sequence" if not packet.payload.parameters.size == 1
        raise "invalid sequence" if not packet.payload.parameters[0] == 1
        
        object_info = get_object_info(packet.payload.parameters[0])
 
        #response
        send_object_info(packet.payload.transaction_id,
                        object_info)
        print "response is sent(object info 1)\n"
        
        #next
        packet = get_packet
        p packet.to_hash#dump
        
        ##stopper
        #next
        packet = get_packet
        p packet.to_hash#dump
        
    end
    
    def delete
        Connections.delete_command_connection(@connection_number)
    end
end


#######################################

class EventConnection < Connection

    def initialize(sock, packet)
        @sock = sock
        @first_packet = packet
        @connection_number = packet.payload.conn_number
                
        #print "Event : "
        #p @first_packet
    end
    
    def get_packet
        bin = @sock.recv(1024)
        raise "event socket closed" if bin == nil or bin == ""
        data = bin.unpack("C*")
        dump_read_data(data)
                            
        packet = PTPIP_packet.new(data)
        #print "Event : "
        #p packet.to_hash
        
        return packet
    end
    
    def send_packet(packet)
        dump_write_data(packet.to_data)#dump
        @sock.send(packet.to_data.pack("C*"), 0)
    end
    
    def send_init_event_ack_pkt
        
        payload = PTPIP_payload_INIT_EVENT_ACK_PKT.new()
        packet = PTPIP_packet.create(payload)
        
        #print "Event : "
        #p packet.to_hash#dump
        
        @sock.send(packet.to_data.pack("C*"), 0)
    end
    
    #########
    def start
    
        self.send_init_event_ack_pkt
        print "init event ack is sent\n"
        
        packet = self.get_packet
                        
    end
    
    def delete
        Connections.delete_event_connection(@first_packet.payload.conn_number)
    end
end

#######################################


#######################################

def dump_data(data)
    print data.join(','), "\n"
end

def dump_read_data(data)
    print "Read : ", data.join(','), "\n"
end


def dump_write_data(data)
    print "Write : ",data.join(','), "\n"
end

#######################################


srv = TCPServer.open(15740);

addr = srv.addr
addr.shift
printf("server is on %s\n", addr.join(":"))


while true
    Thread.start(srv.accept) do |sock|
    
        print sock.addr.join(', '), " <---- ", sock.peeraddr.join(', '), "\n"
            
        begin
        
            #print sock.peeraddr[3], " session start\n
            
            conn = Connection.create_connection(sock)
                
            conn.start
            
        rescue => e
            print "ERROR OCCURED : ", [$!,$@.join("\n")].join("\n")
            
            conn.delete if conn
        end
        
        print "\n"
        print sock.peeraddr.join(', '), " is gone ----\n"
        
                
        sock.shutdown()
        
    end
end
