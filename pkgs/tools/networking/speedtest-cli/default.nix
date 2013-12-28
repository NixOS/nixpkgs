{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "speedtest-cli-${version}";
  version = "0.2.4";
  
  src = fetchurl {
    url = "https://pypi.python.org/packages/source/s/speedtest-cli/speedtest-cli-${version}.tar.gz";
    sha256 = "1mz9lx0sdgjz5w3w2lrfh4g7mdyas0ywqfvwh7hwmmpg0fvqiq5q";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/sivel/speedtest-cli;
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = [ maintainers.iElectric ];
  };
}
