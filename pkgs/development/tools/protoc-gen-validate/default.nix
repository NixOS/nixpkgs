{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-validate";
  version = "0.6.13";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protoc-gen-validate";
    rev = "v${version}";
    sha256 = "sha256-w3qtDMRuMRTjNNjkCBzjgvtzgYABLm/OL94p9M8Db6U=";
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
