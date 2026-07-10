import json
import os
import sys
from configobj import ConfigObj

config = ConfigObj(interpolation=False, encoding="UTF8")
with open(os.environ["NIX_ATTRS_JSON_FILE"]) as f:
    value = json.load(f).get("value")
config.update(value)
config.write(sys.stdout.buffer)
