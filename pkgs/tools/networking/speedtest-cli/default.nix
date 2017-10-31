{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "speedtest-cli-${version}";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "sivel";
    repo = "speedtest-cli";
    rev = "v${version}";
    sha256 = "008a0wymn06h93gdkxwlgxg8039ybdni96i4blhpayj52jkbflnv";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/sivel/speedtest-cli;
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ domenkozar ndowens ];
  };
}
