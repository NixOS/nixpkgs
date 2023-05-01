{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-validate";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protoc-gen-validate";
    rev = "v${version}";
    sha256 = "sha256-tYdWXioiPF1S5lpAipm3UN9NUjXo1/8nx22q28UQFDY=";
  };

  vendorHash = "sha256-OOjVlRHaOLIJVg3r97qZ3lPv8ANYY2HSn7hUJhg3Cfs=";

  excludedPackages = [ "tests" ];

  meta = with lib; {
    description = "Protobuf plugin for generating polyglot message validators";
    homepage = "https://github.com/envoyproxy/protoc-gen-validate";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewpi ];
  };
}
