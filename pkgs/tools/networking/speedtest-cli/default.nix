{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "speedtest-cli-${version}";
  version = "0.2.5";
  
  src = fetchurl {
    url = "https://pypi.python.org/packages/source/s/speedtest-cli/speedtest-cli-${version}.tar.gz";
    sha256 = "0a19kyn6064jbxda4yq1rfrlqlh8ha40fgwkj4rckdzk9bnxkhdn";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/sivel/speedtest-cli;
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = [ maintainers.iElectric ];
  };
}
