import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)

GPIO.setup(17,GPIO.IN)
GPIO.setup(2,GPIO.OUT)
GPIO.setup(3,GPIO.OUT)
GPIO.setup(4,GPIO.OUT)
GPIO.setup(22,GPIO.OUT)

counter=0
last_state=0

def conv_bin(x,digits=0):
    oct2bin=['000','001','010','011','100','101','110','111']
    binstring=[oct2bin[int(n)] for n in oct(x)]
    return ' ',join(binstring).lstrip('0').zfill(digits)
def output_gpio(binstring):
    if(binstring[0]=="1"):
        GPIO.output(22,True)
    else:
        GPIO.output(22,False)

    if(binstring[1]=="1"):
        GPIO.output(4,True)
    else:
        GPIO.output(4,False)

    if(binstring[2]=="1"):
        GPIO.output(3,True)
    else:
        GPIO.output(3,False)

    if(binstring[3]=="1"):
        GPIO.output(2,True)
    else:
        GPIO.output(2,False)
    return

while True:
    input=not GPIO.input(17)
    if(not input):
        last_state=False
        time.sleep(0.1)
    if(input and not last_state):
        last_state=True
        if(counter<16):
            binstring=conv_bin(counter,4)
            print(str(counter)+" : " +binstring)
            output_gpio(binstring)
            counter=counter+1
        else:
            counter=0
            print("Resetting counter....")
        time.sleep(0.1)
