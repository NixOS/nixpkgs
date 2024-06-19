{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-validate";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protoc-gen-validate";
    rev = "v${version}";
    sha256 = "sha256-NPjBVd5Ch8h2+48uymMRjjY6nepmGiY8z9Kwt+wN4lI=";
  };

  vendorHash = "sha256-1bR6cV7R9JEmayE3XN2fcrPQL6xspkKb+WYf+IrOhds=";

  excludedPackages = [ "tests" ];

  meta = with lib; {
    description = "Protobuf plugin for generating polyglot message validators";
    homepage = "https://github.com/envoyproxy/protoc-gen-validate";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewpi ];
  };
}
