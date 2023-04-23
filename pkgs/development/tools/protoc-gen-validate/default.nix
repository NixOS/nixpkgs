{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-validate";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protoc-gen-validate";
    rev = "v${version}";
    sha256 = "sha256-yo0/RhUs9KUdY0l0qqRs3eGWr4y183ZNSCsWihFK++4=";
  };

  vendorHash = "sha256-yGQO5vTdkAr6bKnpaQz//n7r07NGyQg+vQ2BqPGe8Nk=";

  excludedPackages = [ "tests" ];

  meta = with lib; {
    description = "Protobuf plugin for generating polyglot message validators";
    homepage = "https://github.com/envoyproxy/protoc-gen-validate";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewpi ];
  };
}
