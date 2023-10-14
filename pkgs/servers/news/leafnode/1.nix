{ lib, stdenv, fetchurl, pcre2 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "leafnode";
  version = "1.12.0";

  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/leafnode/leafnode/${finalAttrs.version}/leafnode-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-tGfOcyH2F6IeglfY00u199eKusnn6HeqD7or3Oz3ed4=";
  };

  configureFlags = [
    "--with-ipv6"
  ];

  buildInputs = [ pcre2 ];

  meta = {
    homepage = "https://leafnode.sourceforge.io/index.shtml";
    description = "Implementation of a store & forward NNTP proxy, stable release";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.ne9z ];
  };
})
