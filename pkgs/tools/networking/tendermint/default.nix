{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "tendermint";
  version = "0.32.3";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vpnw42a28glghdpgxmqhxd63cnbpghhazpzsdksqkw0i1l36ywr";
  };

  modSha256 = "1h51zgvjq3bm09yhm54rk8a86cqa1zma3mx6pb0kq7k72xvhpx0a";

  meta = with stdenv.lib; {
    description = "Byzantine-Fault Tolerant State Machines. Or Blockchain, for short.";
    homepage = https://tendermint.com/;
    license = licenses.asl20;
    maintainers = with maintainers; [ alexfmpe ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
