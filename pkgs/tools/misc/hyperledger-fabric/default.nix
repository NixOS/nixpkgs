{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "hyperledger-fabric";
  version = "1.3.0";

  goPackagePath = "github.com/hyperledger/fabric";

  # taken from https://github.com/hyperledger/fabric/blob/v1.3.0/Makefile#L108
  subPackages = [
    "common/tools/configtxgen"
    "common/tools/configtxlator"
    "common/tools/cryptogen"
    "common/tools/idemixgen"
    "cmd/discover"
    "peer"
    "orderer"
  ];

  src = fetchFromGitHub {
    owner = "hyperledger";
    repo = "fabric";
    rev = "v${version}";
    sha256 = "08qrrxzgkqg9v7n3y8f2vggyqx9j65wisxi17hrabz5mzaq299xs";
  };

  doCheck = true;

  meta = with lib; {
    description = "An implementation of blockchain technology, leveraging familiar and proven technologies";
    homepage = "https://wiki.hyperledger.org/display/fabric";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
