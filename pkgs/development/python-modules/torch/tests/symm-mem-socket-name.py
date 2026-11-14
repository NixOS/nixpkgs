"""Compile the patched socket-name helper with real c10 error handling.

No socket, GPU operation, or unchecked implementation is executed. The helper
is extracted verbatim; the guard is required before compiling the fixture.
"""

import argparse
import hashlib
import json
from pathlib import Path
import shlex
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--source", type=Path, required=True)
parser.add_argument("--cxx", required=True)
parser.add_argument("--include", type=Path, required=True)
parser.add_argument("--lib", type=Path, required=True)
parser.add_argument("--output", type=Path, required=True)
args = parser.parse_args()
text = args.source.read_text()
start = text.index("std::string IpcChannel::get_socket_name(int pid) {")
end = text.index("\n}", start) + 2
helper = text[start:end]
assert "socket_name.size() < sizeof(sockaddr_un::sun_path)" in helper
assert helper.index("TORCH_CHECK(") < helper.index("return socket_name;")
args.output.mkdir(parents=True, exist_ok=True)
source = args.output / "socket-name.cpp"
source.write_text(
    """#include <c10/util/Exception.h>
#include <sys/un.h>
#include <cstdlib>
#include <sstream>
#include <stdexcept>
#include <string>
struct IpcChannel { static std::string get_socket_name(int); };
"""
    + helper
    + r"""
int main() {
  const char* variables[] = {"TMPDIR", "TMP", "TEMP", "TEMPDIR"};
  auto require = [](bool value) {
    if (!value) throw std::runtime_error("socket-name regression");
  };
  for (auto variable : variables) unsetenv(variable);
  require(IpcChannel::get_socket_name(123) == "/tmp/symm_mem-123");
  for (int i = 3; i >= 0; --i) {
    std::string directory = "/private-" + std::to_string(i);
    setenv(variables[i], directory.c_str(), 1);
    require(IpcChannel::get_socket_name(123) == directory + "/symm_mem-123");
  }
  const std::string suffix = "/symm_mem-123";
  std::string directory(sizeof(sockaddr_un::sun_path) - 1 - suffix.size(), 'x');
  setenv("TMPDIR", directory.c_str(), 1);
  require(IpcChannel::get_socket_name(123) == directory + suffix);
  directory += 'x';
  setenv("TMPDIR", directory.c_str(), 1);
  bool rejected = false;
  try {
    IpcChannel::get_socket_name(123);
  } catch (const c10::Error& error) {
    rejected = std::string(error.what()).find("Set TMPDIR to a shorter directory")
        != std::string::npos;
  }
  require(rejected);
}
"""
)
binary = args.output / "socket-name"
command = [
    *shlex.split(args.cxx), "-std=c++17", "-O2", str(source),
    "-I" + str(args.include), "-L" + str(args.lib),
    "-Wl,-rpath," + str(args.lib), "-lc10", "-o", str(binary),
]
subprocess.run(command, check=True)
subprocess.run([str(binary)], check=True)
(args.output / "results.json").write_text(json.dumps({
    "source": str(args.source),
    "sourceSHA256": hashlib.sha256(args.source.read_bytes()).hexdigest(),
    "helperSHA256": hashlib.sha256(helper.encode()).hexdigest(),
    "command": command,
    "checks": 7,
    "passed": True,
    "scope": "Patched name construction, environment precedence and length validation; no socket or GPU operations.",
}, indent=2) + "\n")
