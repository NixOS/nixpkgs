{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "speedtest-cli-${version}";
  version = "1.0.3";
  
  src = fetchFromGitHub {
    owner = "sivel";
    repo = "speedtest-cli";
    rev = "v${version}";
    sha256 = "160m1liinbpbmjxi3cvdw5x3k9sb4j51ly92lynylpamcqcv8m83";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/sivel/speedtest-cli;
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ domenkozar ndowens ];
  };
}
