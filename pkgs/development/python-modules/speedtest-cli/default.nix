{ lib
, buildPythonPackage
, fetchPypi
}:

# cannot be built as pythonApplication because the library functions are
# required for home-assistant
buildPythonPackage rec {
  pname = "speedtest-cli";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s3ylvkclzdsyqmpjnsd6ixrbmj7vd4bfsdplkjaz1c2czyy3j9p";
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
