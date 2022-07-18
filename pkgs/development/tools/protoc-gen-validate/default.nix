{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-validate";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "envoyproxy";
    repo = "protoc-gen-validate";
    rev = "v${version}";
    sha256 = "sha256-ouo6raNbvQyuY4IY1JEN45Ss7zb3EoR/WIRzL7hXLNI=";
  };

  vendorSha256 = "sha256-HbUEhoB6PPHwN/xym6dTkS54+EqVU1n8EIym8W2wt3I=";

  excludedPackages = [ "tests" ];

  meta = with lib; {
    description = "Protobuf plugin for generating polyglot message validators";
    homepage = "https://github.com/envoyproxy/protoc-gen-validate";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewpi ];
  };
}
