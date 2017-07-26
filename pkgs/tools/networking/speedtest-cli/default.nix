{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "speedtest-cli-${version}";
  version = "1.0.4";
  
  src = fetchFromGitHub {
    owner = "sivel";
    repo = "speedtest-cli";
    rev = "v${version}";
    sha256 = "13i7bvhvwv8h2lxnz9pfxq6jv915lb948d6xjiy5p7rqbki40ng2";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/sivel/speedtest-cli;
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ domenkozar ndowens ];
  };
}
