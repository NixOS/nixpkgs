{ lib, fetchurl, buildPythonApplication, pythonPackages }:

with lib;

buildPythonApplication rec {
  name = "yolk-${version}";
  version = "0.4.3";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/y/yolk/yolk-${version}.tar.gz";
    sha256 = "1f6xwx210jnl5nq0m3agh2p1cxmaizawaf3fwq43q4yw050fn1qw";
  };

  buildInputs = with pythonPackages; [ nose ];

  meta = {
    description = "Command-line tool for querying PyPI and Python packages installed on your system";
    homepage = "https://github.com/cakebread/yolk";
    maintainer = with maintainers; [ profpatsch ];
    license = licenses.bsd3;
  };
}

