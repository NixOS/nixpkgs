{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-validate";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protoc-gen-validate";
    rev = "v${version}";
    sha256 = "sha256-sztpUzrVvYT3GFVbfd91rOudj/PEHHizTOzTrH1fQts=";
  };

  vendorHash = "sha256-UPmeb36kF+z37+RcyXaOsJvAto1xrJUyJqcPyODAQrY=";

  excludedPackages = [ "tests" ];

  meta = with lib; {
    description = "Protobuf plugin for generating polyglot message validators";
    homepage = "https://github.com/envoyproxy/protoc-gen-validate";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewpi ];
  };
}
