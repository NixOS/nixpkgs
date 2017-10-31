{ stdenv, fetchurl, samba, fuse }:

stdenv.mkDerivation rec {
  name = "fusesmb-0.8.7";

  src = fetchurl {
    url = "http://www.ricardis.tudelft.nl/~vincent/fusesmb/download/${name}.tar.gz";
    sha256 = "12gz2gn9iqjg27a233dn2wij7snm7q56h97k6gks0yijf6xcnpz1";
  };

  buildInputs = [ samba fuse ];

  postInstall =
    ''
      mkdir -p $out/lib
      ln -fs ${samba}/lib/libsmbclient.so $out/lib/libsmbclient.so.0
    '';

  hardeningDisable = [ "format" ];

  meta = {
    description = "Samba mounted via FUSE";
    homepage = http://www.ricardis.tudelft.nl/~vincent/fusesmb/;
    platforms = stdenv.lib.platforms.linux;
  };
}
