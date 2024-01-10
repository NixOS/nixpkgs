{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "efm-langserver";
  version = "0.0.49";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "v${version}";
    sha256 = "sha256-sHdULnaLHe4FqP631c4ITNDn62nGJgAIIvO3C4kY3jI=";
  };

  vendorHash = "sha256-ZChHQ0Bcu9sVHvhdrmTfLryRwsFQNQSFDOKRu0keUIo=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "General purpose Language Server";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/mattn/efm-langserver";
    license = licenses.mit;
  };
}
