{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "speedtest-cli-${version}";
  version = "0.3.1";
  namePrefix = "";
  
  src = fetchurl {
    url = "https://pypi.python.org/packages/source/s/speedtest-cli/speedtest-cli-${version}.tar.gz";
    sha256 = "0ln2grbskh39ph79lhcim2axm7hp4xhzbrag8xfqbfihq7jdm6ya";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/sivel/speedtest-cli;
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = [ maintainers.iElectric ];
  };
}
