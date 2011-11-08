{ stdenv, fetchgit, kernel, aufs }:

assert aufs != null;

let version = "20110217"; in

stdenv.mkDerivation {
  name = "aufs2.1-util-${version}-${kernel.version}";

  src = fetchgit {
    url = "git://git.c3sl.ufpr.br/aufs/aufs2-util.git";
    rev = "0f0cf3f2ae39906fd4b5376cdaa24e9fe64a03f4";
    sha256 = "0fce5601b67efe8b5652a813ae612348bf4503aa71056cd31a5ed0406632e364";
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
    description = "Utilities for AUFS2.1";
    homepage = http://aufs.sourceforge.net/;
    maintainers = [ stdenv.lib.maintainers.eelco  ];
    platforms = stdenv.lib.platforms.linux;
  };
}
