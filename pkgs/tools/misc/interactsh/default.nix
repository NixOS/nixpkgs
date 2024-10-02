{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "interactsh";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-0AyFmT0vYYJ5/gTQI2F+fPsM0oBs4CigNCXS3+ECoRo=";
  };

  vendorHash = "sha256-SYs04LgWy6Fd9SUAxs4tB+VK2CK3gqb7fDYkp16i67Q=";

  modRoot = ".";
  subPackages = [
    "cmd/interactsh-client"
    "cmd/interactsh-server"
  ];

  # Test files are not part of the release tarball
  doCheck = false;

  meta = with lib; {
    description = "Out of bounds interaction gathering server and client library";
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
