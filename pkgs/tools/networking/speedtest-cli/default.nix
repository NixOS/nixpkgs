{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "speedtest-cli-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "sivel";
    repo = "speedtest-cli";
    rev = "v${version}";
    sha256 = "06fini7bqf5paphp8dpck1zpmb33cdxlf4hg6xg2g9k4bdm2k26d";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/sivel/speedtest-cli;
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ domenkozar ndowens ];
  };
}
