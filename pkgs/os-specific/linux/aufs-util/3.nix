{ stdenv, fetchgit, kernelDev, aufs }:

assert aufs != null;

stdenv.mkDerivation {
  name = "aufs3-util-${aufs.patch.version}-${kernelDev.version}";

  src = fetchgit {
    url = git://aufs.git.sourceforge.net/gitroot/aufs/aufs-util.git;
    rev = aufs.patch.utilRev;
    sha256 = aufs.patch.utilHash;
  };

  buildInputs = [ aufs ];

  makeFlags =
    [ "KDIR=${kernelDev}/lib/modules/${kernelDev.modDirVersion}/build"
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
    maintainers = [ stdenv.lib.maintainers.eelco  ];
    platforms = stdenv.lib.platforms.linux;
  };
}
