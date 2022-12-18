{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-validate";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protoc-gen-validate";
    rev = "v${version}";
    sha256 = "sha256-5Vr7qE6AFesvBkOpgStxI26m8rbQ8pXOXvNxbcX/ilc=";
  };

  vendorSha256 = "sha256-D8ITrzEwas/UElfsXBG2BfHGFcFsxzWFar2ehgLwy5U=";

  excludedPackages = [ "tests" ];

  meta = with lib; {
    description = "Protobuf plugin for generating polyglot message validators";
    homepage = "https://github.com/envoyproxy/protoc-gen-validate";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewpi ];
  };
}
