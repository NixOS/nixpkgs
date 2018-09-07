{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "speedtest-cli-${version}";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "sivel";
    repo = "speedtest-cli";
    rev = "v${version}";
    sha256 = "0vv2z37g2kgm2dzkfa4bhri92hs0d1acxi8z66gznsl5148q7sdi";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/sivel/speedtest-cli;
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ domenkozar ndowens ];
  };
}
