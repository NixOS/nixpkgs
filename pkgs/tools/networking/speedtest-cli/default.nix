{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "speedtest-cli-${version}";
  version = "0.2.7";
  
  src = fetchurl {
    url = "https://pypi.python.org/packages/source/s/speedtest-cli/speedtest-cli-${version}.tar.gz";
    sha256 = "00r3mjr8852glwryfj9f86pikqg1v0f0xivy25cj86n526wdpy95";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/sivel/speedtest-cli;
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = [ maintainers.iElectric ];
  };
}
