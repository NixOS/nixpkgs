{ stdenv, fetchgit, kernel, aufs3 }:

stdenv.mkDerivation {
  name = "aufs3-util-${aufs3.patch.version}";

  src = fetchgit {
    url = git://aufs.git.sourceforge.net/gitroot/aufs/aufs-util.git;
    rev = aufs3.patch.utilRev;
    sha256 = aufs3.patch.utilHash;
  };

  buildInputs = [ aufs3 ];

  makeFlags =
    [ "KDIR=${kernel}/lib/modules/${kernel.modDirVersion}/build"
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
    description = "Utilities for AUFS3";
    homepage = http://aufs.sourceforge.net/;
    maintainers = [ stdenv.lib.maintainers.eelco 
                    stdenv.lib.maintainers.shlevy ];
    platforms = stdenv.lib.platforms.linux;
  };
}
