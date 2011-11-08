{ stdenv, fetchurl, kernel, aufs }:

assert aufs != null;

let version = "20100506"; in

stdenv.mkDerivation {
  name = "aufs2-util-${version}-${kernel.version}";

  src = fetchurl {
    url = "http://nixos.org/tarballs/aufs2-util-git-${version}.tar.bz2";
    sha256 = "0ly0c3p8fjxqbk8k5rmm1a91wg8wcrvhi1lv4aawalkkk8rqbnwk";
  };

  buildInputs = [ aufs ];

  makeFlags =
    [ "KDIR=${kernel}/lib/modules/${kernel.version}/build"
      "Install=install"
      "DESTDIR=$(out)"
    ];

  postInstall =
    ''
      mv $out/usr/* $out
      rmdir $out/usr

      cp aufs.shlib $out/lib/

      substituteInPlace $out/bin/aubrsync \
        --replace /sbin/mount $out/sbin/mount \
        --replace /usr/lib/aufs.shlib $out/lib/aufs.shlib
    '';

  meta = {
    description = "Utilities for AUFS2";
    homepage = http://aufs.sourceforge.net/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
