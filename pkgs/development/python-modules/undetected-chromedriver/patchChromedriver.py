#!/usr/bin/env python3

import sys
import undetected_chromedriver as uc

if __name__ == "__main__":
    uc.Patcher(executable_path=sys.argv[1]).auto(executable_path=sys.argv[1])

