{ stdenv, buildGoPackage, fetchFromGitHub, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "leaps-${version}";
  version = "0.5.1";

  goPackagePath = "github.com/jeffail/leaps";

  src = fetchFromGitHub {
    owner = "jeffail";
    repo = "leaps";
    sha256 = "0w63y777h5qc8fwnkrbawn3an9px0l1zz3649x0n8lhk125fvchj";
    rev = "v${version}";
  };

  goDeps = ./deps.nix;
  
  meta = {
    description = "A pair programming tool and library written in Golang";
    homepage = https://github.com/jeffail/leaps/;
    license = "MIT";
    maintainers = with stdenv.lib.maintainers; [ qknight ];
    meta.platforms = stdenv.lib.platforms.linux;
  };
}

