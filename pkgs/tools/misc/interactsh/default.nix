{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "interactsh";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-czXcncEm2Wm0ezGjNOpcCin5KOZKuimnnMPUWfGE0FY=";
  };

  vendorSha256 = "sha256-YfHsl0AFNQNCg4HEP9FyrHUMMz0SFn5aDRrOruseE5k=";

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
    license = licenses.mit;
    maintainers = with maintainers; [ hanemile ];
  };
}
