import json
import sys
import unittest

def read_json_lines(f):
    """read lines that are a json object"""
    for line in f:
        try:
            yield json.loads(line)
        except json.JSONDecodeError:
            # ignore lines that are not json
            pass

class BasicTest(unittest.TestCase):
    def test_basic(self):
        tests = [
            log_message_exact(self, "building the system configuration..."),
            run_command_exact(self, ['nix-build', '<nixpkgs/nixos>', '-A', 'system', '-k', '--dry-run']),
        ]
        # this is a generator, so a second test won’t get anything atm
        for (j, test) in zip(read_json_lines(sys.stdin), tests):
            test(j)

def run_command_exact(test, argv):
    return lambda j: test.assertEqual({ "tag": "run_command", "argv": argv }, j)

def log_message_exact(test, msg):
    return lambda j: test.assertEqual({ "tag": "log", "argv": [msg]}, j)

unittest.main()
