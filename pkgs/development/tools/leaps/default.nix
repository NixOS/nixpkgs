{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "leaps";
  version = "0.9.0";

  goPackagePath = "github.com/Jeffail/leaps";

  src = fetchFromGitHub {
    owner = "Jeffail";
    repo = "leaps";
    sha256 = "1bzas7ixyfsfh81lnvplhx59yghkmnmy5p7jv9rnwp219dwbylpz";
    rev = "v${version}";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A pair programming tool and library written in Golang";
    homepage = "https://github.com/jeffail/leaps/";
    license = "MIT";
    maintainers = with lib.maintainers; [ qknight ];
    platforms = lib.platforms.unix;
  };
}
