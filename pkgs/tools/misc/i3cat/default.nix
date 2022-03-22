{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "i3cat";
  version = "1.0";

  goPackagePath = "github.com/vincent-petithory/i3cat";

  src = fetchFromGitHub {
    owner = "vincent-petithory";
    repo = "i3cat";
    rev = "v${version}";
    sha256 = "sha256-BxiiYzSjvXAMUQSUTKviLvrmGjkCLW6QPrgBBHvvF+Q=";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "combine multiple i3bar JSON inputs into one to forward to i3bar";
    homepage = "https://vincent-petithory.github.io/i3cat/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
