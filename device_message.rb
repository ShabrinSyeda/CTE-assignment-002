class DeviceMessage
  attr_accessor :hash,:result

  def initialize(hash,options={})
    @hash = hash
    @result = {}
  end

  def as_json(options={})
    root  = options[:root] || root_method
    @hash = @hash.is_a?(Array) ? @hash : @hash.nil? ? [] : [@hash]
    @hash.each_with_index do |hash,index|
      @result["#{root} ""#{index+1}"]= to_json(hash,options)
    end
    puts  @result
  end

  def to_json(hash,options)
    property_key  = options[:property_key] || property_key_method
    payload_key  = options[:payload_key] || payload_key_method
    pro_hash = hash[property_key]
    payload_hash = hash[payload_key][:options]
    {
        user_id: pro_hash[:user_id],
        message: payload_hash[:alert_message] + (payload_hash[:silent] == true  ? "#{payload_hash[:badge_count]}" : ""),
        message_type: payload_hash[:notification_type],
        pop_up: payload_hash[:silent],
        publish_at: pro_hash[:effective_date],
        target: device_map[payload_hash[:devices].split("=>")[0].strip],
        device_id: payload_hash[:devices].split("=>")[1].strip
    }
  end

  def device_map
    {"android" => "gcm", "ios" => "apn"}
  end

  def root_method
    "payload"
  end

  def property_key_method
    :properties
  end

  def payload_key_method
    :payload
  end

end

# To execute the code follow the below steps

hash = [{
            "properties": {
    "user_id":43,
    "managing_user_id":43,
    "description":"Push Notification",
    "effective_date":"2015-07-20T06:28:36-05:00",
    "system_date":"2015-07-20T06:28:36-05:00"},
    "payload":{
    "id": 49,
    "options": {
    "devices": "ios => e25454608b6097bc412be42ad9bf39797a698925d947b9d136cbb992f649cc96",
    "alert_message": " You have following notifications ",
    "badge_count":10,
    "created_at":"2015-07-20T06:28:36-05:00",
    "id":48,
    "member_id":25,
    "notification_type": "secure_message",
    "silent":true,
"updated_at":"2015-07-20T06:28:36-05:00"
}
}
},

    {
        "properties": {
    "user_id": 43,
    "managing_user_id": 43,
    "description": "Push Notification",
    "effective_date": "2015-07-21T06:28:36-05:00",
    "system_date": "2015-07-21T06:28:36-05:00"
},
    "payload":
    {
        "id": 48,
    "options": {
    "devices": "android => e25454608b6097bc412be42ad9bf39797a698925d947b9d136cbb992f649cc96",
    "alert_message": "This is a sample push notification message",
    "badge_count": 0,
    "created_at": "2015-07-21T06:28:36-05:00",
    "id":48,
    "member_id": 25,
    "notification_type": "Reminder",
    "silent": false,
"updated_at": "2015-07-21T06:28:36-05:00"
}
}
}
]

j = DeviceMessage.new(hash)
j.as_json
