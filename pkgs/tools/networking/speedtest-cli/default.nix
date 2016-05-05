{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "speedtest-cli-${version}";
  version = "0.3.4";
  
  src = fetchurl {
    url = "mirror://pypi/s/speedtest-cli/speedtest-cli-${version}.tar.gz";
    sha256 = "19i671cd815fcv0x7h2m0a493slzwkzn7r926g8myx1srkss0q6d";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/sivel/speedtest-cli;
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = [ maintainers.iElectric ];
  };
}
