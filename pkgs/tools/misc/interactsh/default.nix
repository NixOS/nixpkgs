{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "interactsh";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ELj80stWOwACsCGmjt2QR8TxBFpvlYmVN7hWDPee8YE=";
  };

  vendorHash = "sha256-xm7Iup4+xhcJ+Bzv56A0C3+2Fxz53qY8fqlVsMtFLd8=";

  modRoot = ".";
  subPackages = [
    "cmd/interactsh-client"
    "cmd/interactsh-server"
  ];

  # Test files are not part of the release tarball
  doCheck = false;

  meta = with lib; {
    description = "An Out of bounds interaction gathering server and client library";
    longDescription = ''
      Interactsh is an Open-Source Solution for Out of band Data Extraction,
      A tool designed to detect bugs that cause external interactions,
      For example - Blind SQLi, Blind CMDi, SSRF, etc.
    '';
    homepage = "https://github.com/projectdiscovery/interactsh";
    changelog = "https://github.com/projectdiscovery/interactsh/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hanemile ];
  };
}
