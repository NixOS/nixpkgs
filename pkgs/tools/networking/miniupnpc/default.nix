{ stdenv, fetchFromGitHub }:

let version = "24d54ba13af4e53aba19c23898a373feecb41bd0"; in
stdenv.mkDerivation rec {
  name = "miniupnpc-${version}";

  src = fetchFromGitHub {
    owner = "miniupnp";
    repo = "miniupnp";
    sha256 = "0j78dvlfh1a3a27zhvv001cb1d7vcgyv33bd1zr36drg64b6hrgw";
    rev = version;
  };

  doCheck = true;

  installFlags = "PREFIX=$(out) INSTALLPREFIX=$(out)";

  meta = {
    inherit version;
    homepage = http://miniupnp.free.fr/;
    description = "A client that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.freebsd;
  };
}
