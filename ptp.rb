

#functional mode
PTP_FM_StandardMode = 0x0000
PTP_FM_SleepState = 0x00001

#operation code
PTP_OC_Undefinded = 0x1000
PTP_OC_GetDeviceInfo = 0x1001
PTP_OC_OpenSession = 0x1002
PTP_OC_CloseSession = 0x1003
PTP_OC_GetStorageIDs = 0x1004
PTP_OC_GetStorageInfo = 0x1005
PTP_OC_GetNumObjects = 0x1006
PTP_OC_GetObjectHandles = 0x1007
PTP_OC_GetObjectInfo = 0x1008
PTP_OC_GetObject = 0x1009
PTP_OC_GetThumb = 0x100A
PTP_OC_DeleteObject = 0x100B
PTP_OC_SendObjectInfo = 0x100C
PTP_OC_SendObject = 0x100D
PTP_OC_InitiateCapture = 0x100E
PTP_OC_FormatStore = 0x100F
PTP_OC_ResetDevice = 0x1010
PTP_OC_SelfTest = 0x1011
PTP_OC_SetObjectProtection = 0x1012
PTP_OC_PowerDown = 0x1013
PTP_OC_GetDevicePropDesc = 0x1014
PTP_OC_GetDevicePropValue = 0x1015
PTP_OC_SetDevicePropValue = 0x1016
PTP_OC_ResetDevicePropValue = 0x1017
PTP_OC_TerminateOpenCapture = 0x1018
PTP_OC_MoveObject = 0x1019
PTP_OC_CopyObject = 0x101A
PTP_OC_GetPartialObject = 0x101B
PTP_OC_InitiateOpenCapture = 0x101C

#operation response
PTP_RC_Undefined = 0x2000
PTP_RC_OK = 0x2001
PTP_RC_GeneralError = 0x2002
PTP_RC_SessionNotOpen = 0x2003
PTP_RC_InvalidTransactionID = 0x2004
PTP_RC_OperationNotSupported = 0x2005
PTP_RC_ParameterNotSupported = 0x2006
PTP_RC_IncompleteTransfer = 0x2007
PTP_RC_InvalidStorageID = 0x2008
PTP_RC_InvalidObjectHandle = 0x2009
PTP_RC_DevicePropNotSupported = 0x200a
PTP_RC_InvalidObjectFormatCode = 0x200b
PTP_RC_StoreFull = 0x200c
PTP_RC_ObjectWriteProtected = 0x200d
PTP_RC_StoreReadOnly = 0x200e
PTP_RC_AcceddDenied = 0x200f
PTP_RC_NoThumbnailPresent = 0x2010
PTP_RC_SelfTestFailed = 0x2011
PTP_RC_PartialDeletion = 0x2012
PTP_RC_StoreNotAvailable = 0x2013
PTP_RC_SpecificationByFormatUnsupported = 0x2014
PTP_RC_NoValidObjectInfo = 0x2015
PTP_RC_InvalidCodeFormat = 0x2016
PTP_RC_UnknownVendorCode = 0x2017
PTP_RC_CaptureAlreadyTerminated = 0x2018
PTP_RC_DeviceBusy = 0x2019
PTP_RC_InvalidParentObject = 0x201a
PTP_RC_InvalidDevicePropFormat = 0x201b
PTP_RC_InvalidDevicePropValue = 0x201c
PTP_RC_InvalidParameter = 0x201d
PTP_RC_SessionAlreadyOpen = 0x201e
PTP_RC_TransactionCancelled = 0x201f
PTP_RC_SpecificationofDestinationUnsupported = 0x2020


#error code
PTP_EC_Undefined = 0x4000
PTP_EC_CancelTransaction = 0x4001
PTP_EC_ObjectAdded = 0x4002
PTP_EC_ObjectRemoved = 0x4003
PTP_EC_StoreAdded = 0x4004
PTP_EC_StoreRemoved = 0x4005
PTP_EC_DevicePropChanged = 0x4006
PTP_EC_ObjectInfoChanged = 0x4007
PTP_EC_DeviceInfoChanged = 0x4008
PTP_EC_RequestObjectTransfer = 0x4009
PTP_EC_StoreFull = 0x400a
PTP_EC_DeviceReset = 0x400b
PTP_EC_StorageInfoChanged = 0x400c
PTP_EC_CaptureComplete = 0x400d
PTP_EC_UnreportedStatus = 0x400e

#device prop code
PTP_DPC_Undefined = 0x5000
PTP_DPC_BatteryLevel = 0x5001
PTP_DPC_FunctionalMode = 0x5002
PTP_DPC_ImageSize = 0x5003
PTP_DPC_CompressionSetting = 0x5004
PTP_DPC_WiteBalance = 0x5005
PTP_DPC_RGBGain = 0x5006
PTP_DPC_FNumber = 0x5007
PTP_DPC_FocalLength = 0x5008
PTP_DPC_FocusDistance = 0x5009
PTP_DPC_FocusMode = 0x500a
PTP_DPC_ExposureMeteringMode = 0x500b
PTP_DPC_FlashMode = 0x500c
PTP_DPC_ExposureTime = 0x500d
PTP_DPC_ExposureProgramMode = 0x500e
PTP_DPC_ExposureIndex = 0x500f
PTP_DPC_ExposureBiasCompensation = 0x5010
PTP_DPC_DateTime = 0x5011
PTP_DPC_CaptureDelay = 0x5012
PTP_DPC_StillCaptureMode = 0x5013
PTP_DPC_Contrast = 0x5014
PTP_DPC_Sharpness = 0x5015
PTP_DPC_DigitalZoom = 0x5016
PTP_DPC_EffectMode = 0x5017
PTP_DPC_BurstNumber = 0x5018
PTP_DPC_BurstInterval = 0x5019
PTP_DPC_TimelapseNumber = 0x501a
PTP_DPC_TimelapseInterval = 0x501b
PTP_DPC_FocusMeteringMode = 0x501c
PTP_DPC_UploadURL = 0x501d
PTP_DPC_Artist = 0x501e
PTP_DPC_CopyrightInfo = 0X501F

#object format code
PTP_OFC_Undefined = 0x3000
PTP_OFC_Association = 0x3001
PTP_OFC_Script = 0x3002
PTP_OFC_Executable = 0x3003
PTP_OFC_Text = 0x3004
PTP_OFC_HTML = 0x3005
PTP_OFC_DPOF = 0x3006
PTP_OFC_AIFF = 0x3007
PTP_OFC_WAV = 0x3008
PTP_OFC_MP3 = 0x3009
PTP_OFC_AVI = 0x300a
PTP_OFC_MPEG = 0x300b
PTP_OFC_ASF = 0x300c
PTP_OFC_Unknown = 0x3800
PTP_OFC_EXIF_JPEG = 0x3801
PTP_OFC_TIFF_EP = 0x3802
PTP_OFC_FlashPix = 0x3803
PTP_OFC_BMP = 0x3804
PTP_OFC_CIFF = 0x3805
PTP_OFC_GIF = 0x3807
PTP_OFC_JFIF = 0x3808
PTP_OFC_PCD = 0x3809
PTP_OFC_PICT = 0x380a
PTP_OFC_PNG = 0x380b
PTP_OFC_TIFF = 0x380d
PTP_OFC_TIFF_IT = 0x380e
PTP_OFC_JP2 = 0x380f
PTP_OFC_JPX = 0x3810
PTP_OFC_AncillaryDataFile = 0x3000
PTP_OFC_ImageFile = 0x3800

#storage types
PTP_ST_Undefined = 0x0000
PTP_ST_FixedROM = 0x0001
PTP_ST_RemovableROM = 0x0002
PTP_ST_FixedRAM = 0x0003
PTP_ST_RemovableRAM = 0x0004

#filesysytem types
PTP_FT_Undefined = 0x0000
PTP_FT_GenericFlat = 0x0001
PTP_FT_GenericHierarchical = 0x0002
PTP_FT_DCF = 0x0003

#access capability
PTP_AC_ReadWrite = 0x0000
PTP_AC_ReadOnly = 0x0001
PTP_AC_ReadOnly_Deletion = 0x0002

#protection status
PTP_PS_NoProtection = 0x0000
PTP_PS_ReadOnly = 0x0001

#association types
PTP_AT_Undefined = 0x0000
PTP_AT_GenericFolder = 0x0001
PTP_AT_Album = 0x0002
PTP_AT_TimeSequence = 0x0003
PTP_AT_HorizontalPanoramic = 0x0004
PTP_AT_VerticalPanoramic = 0x0005
PTP_AT_2DPanoramic = 0x0006
PTP_AT_AncillaryData = 0x0007

#devicde prop desc
PTP_DPD_Get = 0x00
PTP_DPD_Set = 0x01
PTP_DPD_FormFlag_None = 0x00
PTP_DPD_FormFlag_Range = 0x01
PTP_DPD_FormFlag_Enum = 0x02

#white balance
PTP_WB_Undefined = 0x0000
PTP_WB_Manual = 0x0001
PTP_WB_Automatic = 0x0002
PTP_WB_OnePushAutomatic = 0x0003
PTP_WB_Daylight = 0x0004
PTP_WB_Florescent = 0x0005
PTP_WB_Tungsten = 0x0006
PTP_WB_Flush = 0x0007

#focus mode
PTP_FCM_Undefined = 0x0000
PTP_FCM_Manual = 0x0001
PTP_FCM_Automatic = 0x0002
PTP_FCM_AutomaticMacro = 0x0003

#exposure metering mode
PTP_EMM_Undefined = 0x0000
PTP_EMM_Avarage = 0x0001
PTP_EMM_CenterWeightedAvarage = 0x0002
PTP_EMM_MultiSpot = 0x0003
PTP_EMM_CenterSpot = 0x0004

#flash mode
PTP_FLM_Undefined = 0x0000
PTP_FLM_AutoFlash = 0x0001
PTP_FLM_FlashOff = 0x0002
PTP_FLM_FillFlash = 0x0003
PTP_FLM_RedEyeAuto = 0x0004
PTP_FLM_RedEyeFill = 0x0005
PTP_FLM_ExternalSync = 0x0006

#exposure program mode
PTP_EPM_Undefined = 0x0000
PTP_EPM_Manual = 0x0001
PTP_EPM_Automatic = 0x0002
PTP_EPM_AperturePriority = 0x0003
PTP_EPM_SutterPriority = 0x0004
PTP_EPM_ProgramCreative = 0x0005
PTP_EPM_ProgramAction = 0x0006
PTP_EPM_Portrait = 0x0007

#still capture mode
PTP_SCM_Undefined = 0x0000
PTP_SCM_Normal = 0x0001
PTP_SCM_Burst = 0x0002
PTP_SCM_Timelapse = 0x0003

#effect mode
PTP_EM_Undefined = 0x0000
PTP_EM_Standard = 0x0001
PTP_EM_BlackWhite = 0x0002
PTP_EM_Sepia = 0x0003

#focus metering mode
PTP_FMM_Undefined = 0x0000
PTP_FMM_CenterSpot = 0x0001
PTP_FMM_MultiSpot = 0x0002


#utilities
def PTP_parse_short(offset, data)
    return data[offset..offset+1].pack("C*").unpack("S")[0], offset+2
end
def PTP_parse_long(offset, data)
    return data[offset..offset+3].pack("C*").unpack("L")[0], offset+4
end
def PTP_parse_string(offset, data)
    i = offset
    until data[i] == 0 && data[i+1] == 0 do
        i+=2
    end
    if i == offset then
        return "", i+2
    else
        return data[offset..i-1].pack("C*").unpack("S*").pack("U*"), i+2
    end
end

def PTP_parse_short_array(offset, data)
    ret = []
    num, start = PTP_parse_long(offset, data)
    num.times do
        s, start = PTP_parse_short(start, data)
        ret << s
    end
    return ret, start
end

def PTP_parse_long_array(offset, data)
    ret = []
    num, start = PTP_parse_long(offset, data)
    num.times do
        s, start = PTP_parse_long(start, data)
        ret << s
    end
    return ret, start
end

class PTP_DeviceInfo
    
    attr_accessor :standard_version, :vender_extension_id, :vender_extension_version, :vender_extention_desc, :functional_mode, :operations_supported, :events_supported, :device_properties_supported, :capture_formats, :image_formats, :manufacturer, :model, :device_version, :serial_number

    def initialize()
        @standard_version = 0
        @vender_extension_id = 0
        @vender_extension_version = 0
        @vender_extention_desc = ""
        @functional_mode = PTP_FM_StandardMode
        @operations_supported = [] #operation code array
        @events_supported = [] #event code array
        @device_properties_supported = [] #device prop code array
        @capture_formats = [] #object format code array
        @image_formats = [] #object format code array
        @manufacturer = "" #
        @model = ""
        @device_version = ""
        @serial_number = ""
    end

    class << self
        def create(data)
            info = new()
            offset = 0
            info.standard_version, offset = PTP_parse_short(offset, data)
            info.vender_extension_id, offset = PTP_parse_long(offset, data)
            info.vender_extension_version, offset = PTP_parse_short(offset, data)
            info.vender_extention_desc, offset = PTP_parse_string(offset, data)
            info.functional_mode, offset = PTP_parse_short(offset, data)
            info.operations_supported, offset = PTP_parse_short_array(offset, data)
            info.events_supported, offset = PTP_parse_short_array(offset, data)
            info.device_properties_supported, offset = PTP_parse_short_array(offset, data)
            info.capture_formats, offset = PTP_parse_short_array(offset, data)
            info.image_formats, offset = PTP_parse_short_array(offset, data)
            info.manufacturer, offset = PTP_parse_string(offset, data)
            info.model, offset = PTP_parse_string(offset, data)
            info.device_version, offset = PTP_parse_string(offset, data)
            info.serial_number, offset = PTP_parse_string(offset, data)
            return info
        end
    end

    def to_data
        [@standard_version].pack("S").unpack("C*")+
        [@vender_extension_id].pack("L").unpack("C*")+
        [@vender_extension_version].pack("S").unpack("C*")+
        
        [@vender_extention_desc.size+1].pack("C").unpack("C")+
        @vender_extention_desc.unpack("U*").pack("S*").unpack("C*")+
        "\0".unpack("U*").pack("S*").unpack("C*")+
        
        [@functional_mode].pack("S").unpack("C*")+
        
        [@operations_supported.size].pack("L").unpack("C*")+
        @operations_supported.pack("S*").unpack("C*")+
        
        [@events_supported.size].pack("L").unpack("C*")+
        @events_supported.pack("S*").unpack("C*")+
        
        [@device_properties_supported.size].pack("L").unpack("C*")+
        @device_properties_supported.pack("S*").unpack("C*")+
        
        [@capture_formats.size].pack("L").unpack("C*")+
        @capture_formats.pack("S*").unpack("C*")+
        
        [@image_formats.size].pack("L").unpack("C*")+
        @image_formats.pack("S*").unpack("C*")+
        
        [@manufacturer.size+1].pack("C").unpack("C")+
        @manufacturer.unpack("U*").pack("S*").unpack("C*")+
        "\0".unpack("U*").pack("S*").unpack("C*")+
        
        [@model.size+1].pack("C").unpack("C")+
        @model.unpack("U*").pack("S*").unpack("C*")+
        "\0".unpack("U*").pack("S*").unpack("C*")+
        
        [@device_version.size+1].pack("C").unpack("C")+
        @device_version.unpack("U*").pack("S*").unpack("C*")+
        "\0".unpack("U*").pack("S*").unpack("C*")+
        
        [@serial_number.size+1].pack("C").unpack("C")+
        @serial_number.unpack("U*").pack("S*").unpack("C*")+
        "\0".unpack("U*").pack("S*").unpack("C*")
    end
    
    def to_hash
        {
        :standard_version => @standard_version,
        :vender_extension_id => @vender_extension_id,
        :vender_extension_version => @vender_extension_version,
        :vender_extention_desc => @vender_extention_desc,
        :functional_mode => @functional_mode,
        :operations_supported => @operations_supported,
        :events_supported => @events_supported,
        :device_properties_supported => @device_properties_supported,
        :capture_formats => @capture_formats,
        :image_formats => @image_formats,
        :manufacturer => @manufacturer,
        :model => @model,
        :device_version => @device_version,
        :serial_number => @serial_number,
        }
    end
    
    
    def to_s
        self.to_hash.to_s
    end

end

def PTP_CreateStrageID(physical_strage_id, logical_strage_id)
    [physical_strage_id, logical_strage_id].pack("SS").unpack("L")[0]
end

def PTP_GetPhisicalStrageID()
    abort()
end
def PTP_GetLogicalStrageID()
    abort()
end

class PTP_StorageInfo
    def initialize()
        @storage_type = 0 #S
        @filesystem_type = 0 #S
        @access_capability = 0 #S
        @max_capability_low = 0 #L
        @max_capability_high = 0 #L
        @free_space_in_bytes_low = 0 #L
        @free_space_in_bytes_high = 0 #L
        @free_space_in_images = 0 #L
        @storage_description = "" #U
        @volume_label = "" #U
    end
    
    def to_data
        [@storage_type].pack("S").unpack("C*")+
        [@filesystem_type].pack("S").unpack("C*")+
        [@access_capability].pack("S").unpack("C*")+
        [@max_capability_low].pack("L").unpack("C*")+
        [@max_capability_high].pack("L").unpack("C*")+
        [@free_space_in_bytes_low].pack("L").unpack("C*")+
        [@free_space_in_bytes_high].pack("L").unpack("C*")+
        [@free_space_in_images].pack("L").unpack("C*")+
        @storage_description.unpack("U*").pack("S*").unpack("C*")+
        "\0".unpack("U*").pack("S*").unpack("C*")+
        @volume_label.unpack("U*").pack("S*").unpack("C*")+
        "\0".unpack("U*").pack("S*").unpack("C*")
    end
    
    def to_hash
        {
        :storage_type => @storage_type,
        :filesystem_type => @filesystem_type,
        :access_capability => @access_capability,
        :max_capability => ((@max_capability_high << 32) |
                                @max_capability_low),
        :free_space_in_bytes => ((@free_space_in_bytes_high << 32) |
                                @free_space_in_bytes_low),
        :free_space_in_images => @free_space_in_images,
        :storage_description => @storage_description,
        :volume_label => @volume_label,
        }
    end
    
    def to_s
        self.to_hash.to_s
    end
end


class PTP_ObjectInfo

    def initialize()
        @storage_id = 0 #L
        @object_format = PTP_OFC_Undefined #S
        @protection_status = PTP_PS_NoProtection #S
        @object_compressed_size = 0 #L
        @thumb_format = PTP_OFC_Undefined#S
        @thumb_compressed_size = 0 #L
        @thumb_pix_width = 0 #L
        @thumb_pix_height = 0 #L
        @image_pix_width = 0 #L
        @image_pix_height = 0 #L
        @image_bit_depth = 0 #L
        @parent_object = 0 #L
        @association_type = PTP_AT_Undefined #S
        @association_desc = 0 #L
        @sequence_number = 0 #L
        @filename = ""
        @capture_date = ""
        @modification_date = ""
        @keywords = ""#'_' separeted
    end
    
    def to_data
        [@storage_id].pack("L").unpack("C*")+
        [@object_format].pack("S").unpack("C*")+
        [@protection_status].pack("S").unpack("C*")+
        [@object_compressed_size].pack("L").unpack("C*")+
        [@thumb_format].pack("S").unpack("C*")+
        [@thumb_compressed_size].pack("L").unpack("C*")+
        [@thumb_pix_width].pack("L").unpack("C*")+
        [@thumb_pix_height].pack("L").unpack("C*")+
        [@image_pix_width].pack("L").unpack("C*")+
        [@image_pix_height].pack("L").unpack("C*")+
        [@image_bit_depth].pack("L").unpack("C*")+
        [@parent_object].pack("L").unpack("C*")+
        [@association_type].pack("S").unpack("C*")+
        [@association_desc].pack("L").unpack("C*")+
        [@sequence_number].pack("L").unpack("C*")+
        @filename.unpack("U*").pack("S*").unpack("C*")+
        "\0".unpack("U*").pack("S*").unpack("C*")+
        @capture_date.unpack("U*").pack("S*").unpack("C*")+
        "\0".unpack("U*").pack("S*").unpack("C*")+
        @modification_date.unpack("U*").pack("S*").unpack("C*")+
        "\0".unpack("U*").pack("S*").unpack("C*")+
        @keywords.unpack("U*").pack("S*").unpack("C*")+
        "\0".unpack("U*").pack("S*").unpack("C*")
    end
    
    def to_hash
        {
        :storage_id => @storage_id,
        :object_format => @object_format,
        :protection_status => @protection_status,
        :object_compressed_size => @object_compressed_size,
        :thumb_format => @thumb_format,
        :thumb_compressed_size => @thumb_compressed_size,
        :thumb_pix_width => @thumb_pix_width,
        :thumb_pix_height => @thumb_pix_height,
        :image_pix_width => @image_pix_width,
        :image_pix_height => @image_pix_height,
        :image_bit_depth => @image_bit_depth,
        :parent_object => @parent_object,
        :association_type => @association_type,
        :association_desc => @association_desc,
        :sequence_number => @sequence_number,
        :filename => @filename,
        :capture_date => @capture_date,
        :modification_date => @modification_date,
        :keywords => @keywords,
        }
    end
    
    def to_s
        self.to_hash.to_s
    end
end

def PTP_CreateDateTimeString(date)
    return nil if not date.to_a? Date
    date.strftime("%Y%m%dT%H%M%S")
end
