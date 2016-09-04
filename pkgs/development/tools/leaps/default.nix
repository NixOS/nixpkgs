{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "leaps-${version}";
  version = "20160626-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "5cf7328a8c498041d2a887e89f22f138498f4621";

  goPackagePath = "github.com/jeffail/leaps";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/jeffail/leaps";
    sha256 = "1qbgz48x9yi0w9yz39zsnnhx5nx2xmrns9v8hx28jah2bvag6sq7";
    fetchSubmodules = false;  
  };

  goDeps = ./deps.json;
  meta = {
    description = "A pair programming tool and library written in Golang";
    homepage = "https://github.com/jeffail/leaps/";
    license = "MIT";
    maintainers = with stdenv.lib.maintainers; [ qknight ];
    meta.platforms = stdenv.lib.platforms.linux;
    broken = true;
  };
}
