{ lib, buildGoModule, fetchFromGitHub, sqlite }:

buildGoModule rec {
  pname = "vitess";
  version = "16.0.0";

  src = fetchFromGitHub {
    owner = "vitessio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Gvk608nM7Uiazuf9qzmd0uzBP4vPSQfkpAWvnSeWm84=";
  };

  vendorHash = "sha256-3GqEMoFYm0TZihoPINf8mwCl3Ky6Lt+LxueYLoFDj2g=";

  buildInputs = [ sqlite ];

  subPackages = [ "go/cmd/..." ];

  # integration tests require access to syslog and root
  doCheck = false;

  meta = with lib; {
    homepage = "https://vitess.io/";
    changelog = "https://github.com/vitessio/vitess/releases/tag/v${version}";
    description = "A database clustering system for horizontal scaling of MySQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
