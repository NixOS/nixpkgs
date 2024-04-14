{ lib
, buildPythonPackage
, fetchPypi
}:

# cannot be built as pythonApplication because the library functions are
# required for home-assistant
buildPythonPackage rec {
  pname = "speedtest-cli";
  version = "2.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w4h7m0isbvfy4zx6m5j4594p5y4pjbpzsr0h4yzmdgd7hip69sy";
  };

  # tests require working internet connection
  doCheck = false;

  meta = with lib; {
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    homepage = "https://github.com/sivel/speedtest-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu domenkozar ];
  };
}
