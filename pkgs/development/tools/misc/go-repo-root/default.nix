{ lib, goPackages, fetchFromGitHub }:

let
  version = "0.0.1";
in

with lib; with goPackages;
buildGoPackage rec {
  name = "go-repo-root-${version}";
  goPackagePath = "github.com/cstrahan/go-repo-root";
  src = fetchFromGitHub {
    owner = "cstrahan";
    repo = "go-repo-root";
    rev = "90041e5c7dc634651549f96814a452f4e0e680f9";
    sha256 = "1rlzp8kjv0a3dnfhyqcggny0ad648j5csr2x0siq5prahlp48mg4";
  };

  buildInputs = [ tools ];

  meta = with lib; {
    homepage    = "https://github.com/cstrahan/go-repo-root";
    maintainers = with maintainers; [ cstrahan ];
    license     = licenses.mit;
    platforms   = platforms.all;
  };
}
