import json
import sys
from configobj import ConfigObj

config = ConfigObj(interpolation=False, encoding="UTF8")
config.update(json.load(sys.stdin))
config.write(sys.stdout.buffer)
