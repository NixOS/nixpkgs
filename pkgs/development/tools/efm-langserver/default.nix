{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "efm-langserver";
  version = "0.0.50";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "v${version}";
    sha256 = "sha256-3WnMEkDa1boExyOg30wiFqs1Nw/zMtBqoUmtjluTQ0Y=";
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
