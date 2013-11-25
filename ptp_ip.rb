
#packet type
PTPIP_PT_InvalidValue = 0x00000000
PTPIP_PT_IniCommandRequestPacket = 0x00000001
PTPIP_PT_InitCommandAck = 0x00000002
PTPIP_PT_InitEventRequestPacket = 0x00000003
PTPIP_PT_InitEventAckPacket = 0x00000004
PTPIP_PT_InitFailPacket = 0x00000005
PTPIP_PT_OperationRequestPacket = 0x00000006
PTPIP_PT_OperationResponsePacket = 0x00000007
PTPIP_PT_EventPacket = 0x00000008
PTPIP_PT_StartDataPacket = 0x00000009
PTPIP_PT_DataPacket = 0x0000000A
PTPIP_PT_CancelPacket = 0x0000000B
PTPIP_PT_EndDataPacket = 0x0000000C
PTPIP_PT_ProbeRequestPacket = 0x0000000D
PTPIP_PT_ProbeResponsePacket = 0x0000000E



class PTPIP_packet

    
    attr_accessor :length
    attr_accessor :type
    attr_accessor :payload
        
    def initialize(data = nil)
    
        @length = 0
        @type = 0
        @payload = nil
        
        if data then
    
            @length = parse_length data
            
            #print @length, " < length\n"###
            
            raise "Invalid Data : length is invalid" if @length != data.length
            
            @type = parse_type data
                    
            #print @type, " < type\n"###
            #print PTP_PACKT_TYPE_STRING[@type], " < type\n"
            
            case @type
            when PTPIP_PT_InvalidValue
                raise "Invalid Data : type is invalid"
            when PTPIP_PT_IniCommandRequestPacket
                @payload = PTPIP_payload_INIT_CMD_PKT.create(data[8..-1])
            when PTPIP_PT_InitCommandAck
                @payload = PTPIP_payload_INIT_CMD_ACK.create(data[8..-1])
            when PTPIP_PT_InitEventRequestPacket
                @payload = PTPIP_payload_INIT_EVENT_REQ_PKT.create(data[8..-1])
            when PTPIP_PT_InitEventAckPacket
                @payload = PTPIP_payload_INIT_EVENT_ACK_PKT.create(nil)
            when PTPIP_PT_InitFailPacket
                @payload = PTPIP_payload_INIT_FAIL_PKT.create(data[8..-1])
            when PTPIP_PT_OperationRequestPacket
                @payload = PTPIP_payload_OPERATION_REQ_PKT.create(data[8..-1])
            when PTPIP_PT_OperationResponsePacket
                @payload = PTPIP_payload_OPERATION_RES_PKT.create(data[8..-1])
            when PTPIP_PT_EventPacket
                @payload = PTPIP_payload_EVENT_PKT.create(data[8..-1])
            when PTPIP_PT_StartDataPacket
                @payload = PTPIP_payload_START_DATA_PKT.create(data[8..-1])
            when PTPIP_PT_DataPacket
                @payload = PTPIP_payload_DATA_PKT.create(data[8..-1])
            when PTPIP_PT_CancelPacket
                @payload = PTPIP_payload_CANCEL_PKT.create(data[8..-1])
            when PTPIP_PT_EndDataPacket
                @payload = PTPIP_payload_END_DATA_PKT.create(data[8..-1])
            when PTPIP_PT_ProbeRequestPacket
                @payload = nil
            when PTPIP_PT_ProbeResponsePacket
                @payload = nil
            else
                raise "Invalid Data : type not implimented"
            end
            
            #p @payload
        
        end
        
    end
    
    def self.completed_data?(data)
        return false if data.length < 4
        return data.length == parse_length(data)
    end
    
    def self.create(payload)
        packet = self.new()
        packet.length = 4 + 4 + payload.to_data.length
        packet.type = payload.type
        packet.payload = payload
        return packet
    end
    
    def self.parse_length(data)
        raise "Invalid Data : length" if data.length < 4
        return data[0..3].pack("C*").unpack("L")[0];
    end
    
    def self.parse_type(data)
        raise "Invalid Data : type" if data.length < 8
        return data[4..7].pack("C*").unpack("L")[0];
    end
    
    def to_data
        if @payload then
            [@length].pack("L").unpack("C*")+
            [@type].pack("L").unpack("C*")+
            @payload.to_data
        else
            [@length].pack("L").unpack("C*")+
            [@type].pack("L").unpack("C*")
        end
        
    end
    
    def to_hash
        {
        "length"=>@length,
        "packet_type"=>@type,
        "payload"=>@payload?@payload.to_hash():nil,
        }
    end

    def to_s
        self.to_hash.to_s
    end
end

class PTPIP_payload

    attr_reader :type
    
    def initialize(data = nil)
        @type = PTPIP_PT_InvalidValue
    end
    
    def to_data
        []
    end
    
    def to_hash
        {}
    end

    def to_s
        self.to_hash.to_s
    end

end

class PTPIP_payload_INIT_CMD_PKT < PTPIP_payload

    attr_accessor :guid
    attr_accessor :friendly_name
    attr_accessor :protocol_version
    

    def initialize()
    
        @type = PTPIP_PT_IniCommandRequestPacket
        #initiator information
        @guid = nil
        @friendly_name = nil
        @protocol_version = 0
        
    end
    
    class << self
        def create(data)
            payload = new()
            payload.guid = parse_guid(data)
            payload.friendly_name = parse_friendly_name(data)
            payload.protocol_version = parse_protocol_version(data)
            return payload
        end
        
        def parse_guid(data)
            raise "Invalid Data : guid" if data.length < 16
            return data[0..15];
        end
        
        def parse_friendly_name(data)#ignore null terminate
            raise "Invalid Data : friendly name" if data.length < 20
            return data[16..-6].pack("C*").unpack("S*").pack("U*");
        end
        
        def parse_protocol_version(data)
            raise "Invalid Data : protocol version" if data.length < 20
            return data[-4..-1].pack("C*").unpack("L")[0];
        end
    end
     
    def to_data
        @guid+
        @friendly_name.unpack("U*").pack("S*").unpack("C*")+
        "\0".unpack("U*").pack("S*").unpack("C*") +
        [@protocol_version].pack("L").unpack("C*")
    end
    
    def to_hash
        {
        "Type"=>@type,
        "GUID"=>@guid,
        "FriendlyName"=>@friendly_name,
        "ProtocolVersion"=>@protocol_version,
        }
    end
end

class PTPIP_payload_INIT_CMD_ACK < PTPIP_payload
    
    attr_accessor :conn_number
    attr_accessor :guid
    attr_accessor :friendly_name
    attr_accessor :protocol_version

    
    def initialize()
    
        @type = PTPIP_PT_InitCommandAck
        #responder information
        @conn_number = 0
        @guid = nil
        @friendly_name = nil
        @protocol_version = 0
    end
    
    class << self
        def create(data)
            payload = new()
            payload.guid = parse_guid data
            payload.conn_number = parse_conn_number data
            payload.friendly_name = parse_friendly_name data
            payload.protocol_version = parse_protocol_version data
            return payload
        end
        
        def parse_conn_number(data)
            raise "Invalid Data : connection number" if data.length < 4
            return data[0..3].pack("C*").unpack("L")[0];
        end
        
        def parse_guid(data)
            raise "Invalid Data : guid" if data.length < 20
            return data[4..19];
        end
        
        def parse_friendly_name(data)#ignore null terminate
            return data[20..-6].pack("C*").unpack("S*").pack("U*");
        end
        
        def parse_protocol_version(data)
            return data[-4..-1].pack("C*").unpack("L")[0];
        end
    end
    
    def to_data
        [@conn_number].pack("L").unpack("C*")+
        @guid+
        @friendly_name.unpack("U*").pack("S*").unpack("C*")+
        "\0".unpack("U*").pack("S*").unpack("C*")+
        [@protocol_version].pack("L").unpack("C*")
    end
    
    
    def to_hash
        {
        "Type"=>@type,
        "ConnectionNumber"=>@conn_number,
        "GUID"=>@guid,
        "FriendlyName"=>@friendly_name,
        "ProtocolVersion"=>@protocol_version,
        }
    end

end

class PTPIP_payload_INIT_EVENT_REQ_PKT < PTPIP_payload
        
    attr_accessor :conn_number
    
    def initialize()
        @type = PTPIP_PT_InitEventRequestPacket
        @conn_number = 0
    end
    
    class << self
        def create(data)
            payload = new()
            payload.conn_number = parse_conn_number(data)
            return payload
        end
        
        def parse_conn_number(data)
            raise "Invalid Data : connection_number" if data.length < 4
            return data[0..3].pack("C*").unpack("L")[0];
        end
    end
    
    def to_data
        [@conn_number].pack("L").unpack("C*")
    end
    
    def to_hash
        {
        "Type"=>@type,
        "ConnectionNumber"=>@conn_number,
        }
    end
end

class PTPIP_payload_INIT_EVENT_ACK_PKT < PTPIP_payload
            
    def initialize()
        @type = PTPIP_PT_InitEventAckPacket
    end
    
    class << self
        def create(data)
            payload = new()
        end
    end
    
    def to_data
        return []
    end
    
    def to_hash
        {
        "Type"=>@type,
        }
    end
end


class PTPIP_payload_INIT_FAIL_PKT < PTPIP_payload
    
    FAIL_REJECTED_INITIATOR = 0x00000001
    FAIL_BUSY = 0x00000002
    FAIL_UNSPECIFIED = 0x00000003
    
    attr_accessor :reason
    
    def initialize()
        @type = PTPIP_PT_InitFailPacket
        @reason = 0
    end
    
    class << self
        def create(data)
            payload = new()
            payload.reason = parse_reason(data)
        end
        
        def parse_reason(data)
            raise "Invalid Data : reason" if data.length < 4
            return data[0..3].pack("C*").unpack("L")[0];
        end
    end
    
    def to_data
        [@reason].pack("L").unpack("C*")
    end
    
    def to_hash
        {
        "Type"=>@type,
        "Reason"=>@reason,
        }
    end
end


class PTPIP_payload_OPERATION_REQ_PKT < PTPIP_payload
    
    UNKNOWN_DATA_PHASE = 0x00000000
    NO_DATA_OR_DATA_IN_PHASE = 0x00000001
    DATA_OUT_PHASE = 0x00000002
    
    attr_accessor :data_phase_info
    attr_accessor :operation_code
    attr_accessor :transaction_id
    attr_accessor :parameters
    
    def initialize()
        @type = PTPIP_PT_OperationRequestPacket
        @data_phase_info = 0
        @operation_code = 0
        @transaction_id = 0
        @parameters = []
    end
    
    class << self
        def create(data)
            payload = new()
            payload.data_phase_info = parse_data_phase_info(data)
            payload.operation_code = parse_operation_code(data)
            payload.transaction_id = parse_transaction_id(data)
            payload.parameters = parse_parameters(data)
            return payload
        end
        
        def parse_data_phase_info(data)
            raise "Invalid Data : parse_data_phase_info" if data.length < 4
            return data[0..3].pack("C*").unpack("L")[0];
        end
        
        def parse_operation_code(data)
            raise "Invalid Data : operation_code" if data.length < 6
            return data[4..5].pack("C*").unpack("S")[0];
        end
        
        def parse_transaction_id(data)
            raise "Invalid Data : transaction_id" if data.length < 10
            return data[6..9].pack("C*").unpack("L")[0];
        end
        
        def parse_parameters(data)
            raise "Invalid Data : parameters" if data.length > 30
            return data[10..-1].pack("C*").unpack("L*");
        end
    end
    
    def to_data
        [@data_phase_info].pack("L").unpack("C*")+
        [@operation_code].pack("S").unpack("C*")+
        [@transaction_id].pack("L").unpack("C*")+
        @parameters.pack("L*").unpack("C*")
    end
    
    def to_hash
        {
        "Type"=>@type,
        "DataPhaseInfo"=>@data_phase_info,
        "OperationCode"=>@operation_code,
        "TransactionID"=>@transaction_id,
        "Parameters"=>@parameters,
        }
    end
end

class PTPIP_payload_OPERATION_RES_PKT < PTPIP_payload
    
    attr_accessor :response_code
    attr_accessor :transaction_id
    attr_accessor :parameters
    
    def initialize()
        @type = PTPIP_PT_OperationResponsePacket
        @response_code = 0
        @transaction_id = 0
        @parameters = []
        
    end
    
    class << self
        def create(data)
            payload = new()
            payload.response_code = parse_response_code(data)
            payload.transaction_id = parse_transaction_id(data)
            payload.parameters = parse_parameters(data)
            return payload
        end
        
        def parse_response_code(data)
            raise "Invalid Data : parse_response_code" if data.length < 4
            return data[0..3].pack("C*").unpack("S")[0];
        end
        
        def parse_transaction_id(data)
            raise "Invalid Data : transaction_id" if data.length < 8
            return data[4..7].pack("C*").unpack("L")[0];
        end
        
        def parse_parameters(data)
            raise "Invalid Data : parameters" if data.length > 26
            return data[8..-1].pack("C*").unpack("L*");
        end
    end
    
    def to_data
        [@response_code].pack("S").unpack("C*")+
        [@transaction_id].pack("L").unpack("C*")+
        @parameters.pack("L*").unpack("C*")
    end
    
    def to_hash
        {
        "Type"=>@type,
        "ResponseCode"=>@response_code,
        "TransactionID"=>@transaction_id,
        "Parameters"=>@parameters,
        }
    end
end


class PTPIP_payload_EVENT_PKT < PTPIP_payload
    
    attr_accessor :event_code
    attr_accessor :transaction_id
    attr_accessor :parameters
    
    def initialize()
        @type = PTPIP_PT_EventPacket
        @event_code = 0
        @transaction_id = 0
        @parameters = []
    end
    
    class << self
        def create(data)
            payload = new()
            payload.event_code = parse_event_code(data)
            payload.transaction_id = parse_transaction_id(data)
            payload.parameters = parse_parameters(data)
            return payload
        end
        
        def parse_event_code(data)
            raise "Invalid Data : parse_event_code" if data.length < 4
            return data[0..3].pack("C*").unpack("S")[0];
        end
        
        def parse_transaction_id(data)
            raise "Invalid Data : transaction_id" if data.length < 8
            return data[4..7].pack("C*").unpack("L")[0];
        end
        
        def parse_parameters(data)
            raise "Invalid Data : parameters" if data.length > 18
            return data[8..-1].pack("C*").unpack("L*");
        end
    end
    
    def to_data
        [@event_code].pack("S").unpack("C*")+
        [@transaction_id].pack("L").unpack("C*")+
        @parameters.pack("L*").unpack("C*")
    end
    
    def to_hash
        {
        "Type"=>@type,
        "EventCode"=>@event_code,
        "TransactionID"=>@transaction_id,
        "Parameters"=>@parameters,
        }
    end
end

class PTPIP_payload_START_DATA_PKT < PTPIP_payload
    
    attr_accessor :transaction_id
    attr_accessor :total_data_length_low
    attr_accessor :total_data_length_high
    
    def initialize()
        @type = PTPIP_PT_StartDataPacket
        @transaction_id = 0
        @total_data_length_low = 0
        @total_data_length_high = 0
    end
    
    class << self
        def create(data)
            payload = new()
            payload.transaction_id = parse_transaction_id(data)
            payload.total_data_length_low = parse_total_data_length_low(data)
            payload.total_data_length_high = parse_total_data_length_high(data)
            return payload
        end
        
        def parse_transaction_id(data)
            raise "Invalid Data : transaction_id" if data.length < 4
            return data[0..3].pack("C*").unpack("L")[0];
        end

        
        def parse_total_data_length_low(data)
            raise "Invalid Data : total_data_length_low" if data.length < 12
            return data[4..7].pack("C*").unpack("L")[0];
        end
        
        def parse_total_data_length_high(data)
            raise "Invalid Data : total_data_length_high" if data.length < 12
            return data[8..11].pack("C*").unpack("L")[0];
        end
    end
    
    def to_data
        [@transaction_id].pack("L").unpack("C*")+
        [@total_data_length_low].pack("L").unpack("C*")+
        [@total_data_length_high].pack("L").unpack("C*")
    end
    
    def to_hash
        {
        "Type"=>@type,
        "TransactionID"=>@transaction_id,
        "TotalDatalength(low)"=>@total_data_length_low,
        "TotalDatalength(high)"=>@total_data_length_high,
        }
    end
end

class PTPIP_payload_DATA_PKT < PTPIP_payload
    
    attr_accessor :transaction_id
    attr_accessor :data_payload
    
    def initialize()
        @type = PTPIP_PT_DataPacket
        @transaction_id = 0
        @data_payload = []
    end
    
    class << self
        def create(data)
            payload = new()
            payload.transaction_id = parse_transaction_id(data)
            payload.data_payload = parse_data_payload(data)
            return payload
        end
        
        def parse_transaction_id(data)
            raise "Invalid Data : transaction_id" if data.length < 4
            return data[0..3].pack("C*").unpack("L")[0];
        end

        
        def parse_data_payload(data)
            return data[4..-1];
        end
    end
    
    def to_data
        [@transaction_id].pack("L").unpack("C*")+
        @data_payload
    end
    
    def to_hash
        {
        "Type"=>@type,
        "TransactionID"=>@transaction_id,
        "DataPayload(size)"=>@data_payload.size
        }
    end
end

class PTPIP_payload_CANCEL_PKT < PTPIP_payload
    
    attr_accessor :transaction_id
    
    def initialize()
        @type = PTPIP_PT_CancelPacket
        @transaction_id = 0
    end
    
    class << self
        def create(data)
            payload = new()
            payload.transaction_id = parse_transaction_id(data)
            return payload
        end
    
        def parse_transaction_id(data)
            raise "Invalid Data : transaction_id" if data.length < 4
            return data[0..3].pack("C*").unpack("L")[0];
        end
    end

    def to_data
        [@transaction_id].pack("L").unpack("C*")
    end
    
    def to_hash
        {
        "Type"=>@type,
        "TransactionID"=>@transaction_id,
        }
    end
end

class PTPIP_payload_END_DATA_PKT < PTPIP_payload_DATA_PKT
    
    attr_accessor :transaction_id
    attr_accessor :data_payload
    
    def initialize()
        super
        @type = PTPIP_PT_EndDataPacket
        @transaction_id = 0
        @data_payload = []
    end
    
    class << self
        def self.create(data)
            payload = new()
            payload.transaction_id = parse_transaction_id(data)
            payload.data_payload = parse_data_payload(data)
            return payload
        end
        
        def parse_transaction_id(data)
            raise "Invalid Data : transaction_id" if data.length < 4
            return data[0..3].pack("C*").unpack("L")[0];
        end

        def parse_data_payload(data)
            return data[4..-1];
        end
    end
end


