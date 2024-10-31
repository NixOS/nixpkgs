{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-validate";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protoc-gen-validate";
    rev = "v${version}";
    sha256 = "sha256-QY7MqggMNYq6x1VkkWVGN07VZgkexe7mGj/+6QvJiHs=";
  };

  vendorHash = "sha256-DqM+Am7Pi0UTz7NxYOCMN9W3H6WipX4oRRa8ceMsYZ0=";

  excludedPackages = [ "tests" ];

  meta = with lib; {
    description = "Protobuf plugin for generating polyglot message validators";
    homepage = "https://github.com/envoyproxy/protoc-gen-validate";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewpi ];
  };
}
