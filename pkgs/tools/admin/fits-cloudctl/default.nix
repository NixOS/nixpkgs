{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.10.9";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-FNlbAxU1FiLl74h+BmpAB3+vZ+RgdlpkehsDLhpZ4EE=";
  };

  vendorSha256 = "sha256-f35Asf9l6ZfixpjMGzesTsxmANreilMxH2CULMH3b2o=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
