#!/usr/bin/ruby

#send_address = 'https://humitemp.herokuapp.com:443/humitemps'
send_address = 'http://localhost:3000/humitemps'
access_token = 'qsefthukil'

# ==========

require 'rubygems'
require 'json'
require 'i2c'
require 'sqlite3'
require 'uri'
require 'net/http'
 
include SQLite3

class AM2321

  def initialize(path, address = 0x5c)
    @device = I2C.create(path)
    @address = address
  end

  def crc16(data)
    crc = 0xFFFF
    data.each do |b|
      crc ^= b;
      8.times do
        if (crc & 0x01) != 0 then
          crc = crc >> 1
          crc ^= 0xA001
        else
      crc = crc >> 1
        end
      end
    end
    return crc
  end

  def read
    # Wake up sensor
    begin
      @device.write(@address, "")
    rescue
      # ignore
    end

    # Read sensor values
    begin
      s = @device.read(@address, 8, "\x03\x00\x04")
    rescue
      return nil
    end
    func_code, ret_len, hum_h, hum_l, temp_h, temp_l, crc_l, crc_h = s.bytes.to_a
    orig_crc = (crc_h << 8) | crc_l
    hum = (hum_h << 8) | hum_l
    temp = (temp_h << 8) | temp_l

    # Calc CRC
    crc = crc16(s[0,6].bytes)

    return nil if crc != orig_crc
    return hum/10.0, temp/10.0
  end
end

def http_request(method, uri, query_hash={})
    query = query_hash.map{|k, v| "#{k}=#{v}"}.join('&')        #ハッシュをオプションの書式に変換
    query_escaped = URI.escape(query)
 
    uri_parsed = URI.parse(uri)
    http = Net::HTTP.new(uri_parsed.host, uri_parsed.port)
 
    return http.post(uri_parsed.path, query_escaped).body
end
 
class MyDb 
    def initialize(dbname)
        @db = Database.new('test.db')
        @db.execute('CREATE TABLE IF NOT EXISTS humitemp(id INTEGER PRIMARY KEY AUTOINCREMENT, humidity REAL not null, temperature REAL not null, measured_at INTEGER)')
    end
 
    def insert_humitemp(humidity, temperature, measured_at)
        insert_sql = 'insert into humitemp(humidity, temperature, measured_at) values (?, ?, ?)'
        @db.execute(insert_sql, humidity, temperature, measured_at.to_i)
    end
 
    def find_all_humitemp(&block)
        @db.execute('select id, humidity, temperature, measured_at from humitemp') do |row|
            block.call({:id=>row[0], :humidity=>row[1], :temperature=>row[2], :measured_at=>Time.at(row[3])}) if block
        end
    end
 
    def delete_humitemp(id)
        @db.execute('delete from humitemp where id=?', id)
    end
end

myDb = MyDb.new("my.sqlite3")
sensor = AM2321.new('/dev/i2c-1')
humi, temp =  sensor.read
#humi, temp = [12,34]

myDb.insert_humitemp(humi, temp, Time.now)


myDb.find_all_humitemp() do |row|
  result = http_request('POST', send_address,
  {
    'humitemp[access_token]' => access_token,
    'humitemp[temperature]' => row[:temperature].to_s,
    'humitemp[humidity]' => row[:humidity].to_s,
    'humitemp[measured_at]' => row[:measured_at].utc.to_json
    })
  puts 'Sending: ' + row[:id].to_s + ' : ' + result.to_s
  myDb.delete_humitemp(row[:id]) if result
end
