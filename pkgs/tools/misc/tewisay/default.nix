{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "tewisay-unstable-${version}";
  version = "2017-04-14";
  rev = "e3fc38737cedb79d93b8cee07207c6c86db4e488";

  goPackagePath = "github.com/lucy/tewisay";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/lucy/tewisay.git";
    sha256 = "1na3xi4z90v8qydcvd3454ia9jg7qhinciy6kvgyz61q837cw5dk";
  };

  goDeps = ./deps.nix;

  meta = {
    homepage = https://github.com/lucy/tewisay;
    description = "Cowsay replacement with unicode and partial ansi escape support";
    license = stdenv.lib.licenses.cc0;
    maintainers = [ stdenv.lib.maintainers.chiiruno ];
    platforms = stdenv.lib.platforms.all;
  };
}
