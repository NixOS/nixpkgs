{ lib
, buildPythonPackage
, fetchPypi
}:

# cannot be built as pythonApplication because the library functions are
# required for home-assistant
buildPythonPackage rec {
  pname = "speedtest-cli";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f3d5aa1086d9b367c03b99db6e3207525af174772d877c6b982289b8d2bdefe";
  };

  # tests require working internet connection
  doCheck = false;

  meta = with lib; {
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    homepage = https://github.com/sivel/speedtest-cli;
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu domenkozar ndowens ];
  };
}
