{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "evmdis-unstable-${version}";
  version = "2018-03-23";
  goPackagePath = "github.com/Arachnid/evmdis";

  src = fetchFromGitHub {
    owner = "Arachnid";
    repo = "evmdis";
    rev = "0d1406905c5fda6224651fa53260a21c907eb986";
    sha256 = "09y4j7ipgv8yd99g3xk3f079w8fqfj7kl1y7ry81ainysn0qlqrg";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/Arachnid/evmdis;
    description = "Ethereum EVM disassembler";
    license = [ licenses.asl20 ];
    maintainers = with maintainers; [ asymmetric ];
  };
}
