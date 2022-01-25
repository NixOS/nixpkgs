{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-GSdVwpYmJ3VnZaMQ8SjzcHpeefFjSaZXRcUAXEI9PKo=";
  };

  vendorSha256 = "sha256-RZ4cy9XHpWRP85G4A1/qYPjt/4CZ7pgECf+rsViPjGE=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
