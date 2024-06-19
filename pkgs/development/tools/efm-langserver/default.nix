{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "efm-langserver";
  version = "0.0.53";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "v${version}";
    sha256 = "sha256-Csm+2C9hP+dTXliADUquAb1nC+8f5j1rJ+66cqWDrCk=";
  };

  vendorHash = "sha256-0YkUak6+dpxvXn6nVVn33xrTEthWqnC9MhMLm/yjFMA=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "General purpose Language Server";
    mainProgram = "efm-langserver";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/mattn/efm-langserver";
    license = licenses.mit;
  };
}
