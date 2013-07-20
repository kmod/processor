import serial # easy_install pyserial


# Baud rates linux seems to support:
# 0 50 75 110 134 150 200 300 600 1200 1800 2400 4800 9600 19200 38400 57600 115200 230400 460800 576000 921600 1152000 1500000 3000000...
def test(br):
    ser = serial.Serial("/dev/ttyUSB0", br, timeout=.1)
    try:
        ser.read(1)
    except serial.serialutil.SerialException:
        return False
    finally:
        ser.close()
    return True

# for i in xrange(0, 10000000, 1200):
    # if test(i):
        # print i

ser = serial.Serial("/dev/ttyUSB0", 115200, timeout=1)
print ser.portstr
ser.write("hello")

i = 0
while True:
    c = ser.read(1)
    ser.write(chr(i&0xff))
    i += 1
    print repr(c)
    ser.write(c)
