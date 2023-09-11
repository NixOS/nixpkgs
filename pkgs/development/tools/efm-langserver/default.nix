{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "efm-langserver";
  version = "0.0.48";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "v${version}";
    sha256 = "sha256-do/p4sQ/OoswiC/19gKk5xeWbZ8iEOX5oPg5cY7ofYA=";
  };

  vendorHash = "sha256-+QYJijb5l++fX7W4xVtAZyQwjEsGEuStFAUHPB4cVHE=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "General purpose Language Server";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/mattn/efm-langserver";
    license = licenses.mit;
  };
}
