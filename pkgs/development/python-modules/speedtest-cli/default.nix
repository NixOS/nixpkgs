{ lib
, buildPythonPackage
, fetchPypi
}:

# cannot be built as pythonApplication because the library functions are
# required for home-assistant
buildPythonPackage rec {
  pname = "speedtest-cli";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m1fpsb318mrpliw026a7nhx8iky306rmfi565734k7r49i3h7fg";
  };

  # tests require working internet connection
  doCheck = false;

  meta = with lib; {
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    homepage = https://github.com/sivel/speedtest-cli;
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu domenkozar ];
  };
}
