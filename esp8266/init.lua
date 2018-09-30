--init.lua
time_sleep = 60  -- seconds

-- Wifi settings
wifi_ssid = "*****"
wifi_pwd  = "*****"
wifi_mode = wifi.PHYMODE_N
wifi_ip  ="192.168.1.202"
wifi_mask="255.255.255.0"
wifi_gw  ="192.168.1.1"

-- Domoticz settings
dom_json = "http://192.168.1.50:8080/json.htm"
dom_user = "*****"    -- encoded username !     
dom_pwd  = "*****"    -- encoded password
dom_dev  = "162"      

ledR = 8  -- GPIO15      
ledG = 6  -- GPIO12
ledB = 7  -- GPIO13
led0 = 3
gpio.mode(ledR, gpio.OUTPUT)
gpio.mode(ledG, gpio.OUTPUT)
gpio.mode(ledB, gpio.OUTPUT)
gpio.mode(led0, gpio.OUTPUT)
gpio.write(ledR, gpio.LOW)
gpio.write(ledG, gpio.LOW)
gpio.write(ledB, gpio.LOW)
gpio.write(led0, gpio.LOW)

print("Connecting to WiFi...")
wifi.setmode(wifi.STATION)
wifi.setphymode(wifi_mode)
wifi.sta.config{ssid=wifi_ssid, pwd=wifi_pwd}
wifi.sta.connect()
wifi.sta.setip({ip=wifi_ip,netmask=wifi_mask,gateway=wifi_gw})

val = adc.read(0)
-- gpio.write(ledG, gpio.HIGH)

tmr.alarm(1, 300, 1, function()
  if wifi.sta.status() == 5 then
    -- Stop the loop
    tmr.stop(1)
    print("Sending...")
    http.get( 
        dom_json.."?username="..dom_user.."&password="..dom_pwd.."&type=command&param=udevice&idx="..dom_dev.."&svalue="..val,
        nil,
        function(code, data)
            print(data)
            print("start to sleep ....")
            -- gpio.write(ledG, gpio.LOW)
            node.dsleep(time_sleep*1000*1000)
        end
    )
  else
    print("Connecting...")
  end
end)
