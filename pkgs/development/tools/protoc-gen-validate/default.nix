{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-validate";
  version = "0.6.12";

  src = fetchFromGitHub {
    owner = "envoyproxy";
    repo = "protoc-gen-validate";
    rev = "v${version}";
    sha256 = "sha256-JoOTIteE4/IFsVVXcRI1KYpRONjo3veQ6uCtxYFlz8Y=";
  };

  vendorSha256 = "sha256-vFi1DT7o2fyzxO/aZHtdsU1/G/sGmamqZPeql0vQVjs=";

  excludedPackages = [ "tests" ];

  meta = with lib; {
    description = "Protobuf plugin for generating polyglot message validators";
    homepage = "https://github.com/envoyproxy/protoc-gen-validate";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewpi ];
  };
}
