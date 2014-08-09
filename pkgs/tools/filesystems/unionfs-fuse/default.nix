{ stdenv, fetchurl, cmake, fuse }:

stdenv.mkDerivation rec {
  name = "unionfs-fuse-0.26";

  src = fetchurl {
    url = "http://podgorny.cz/unionfs-fuse/releases/${name}.tar.xz";
    sha256 = "0qpnr4czgc62vsfnmv933w62nq3xwcbnvqch72qakfgca75rsp4d";
  };

  patches =
    [ # Prevent the unionfs daemon from being killed during
      # shutdown. See
      # http://www.freedesktop.org/wiki/Software/systemd/RootStorageDaemons/
      # for details.
      ./prevent-kill-on-shutdown.patch
    ];

  buildInputs = [ cmake fuse ];

  # Put the unionfs mount helper in place as mount.unionfs-fuse. This makes it
  # possible to do:
  #   mount -t unionfs-fuse none /dest -o dirs=/source1=RW,/source2=RO
  #
  # This must be done in preConfigure because the build process removes
  # helper from the source directory during the build.
  preConfigure = ''
    mkdir -p $out/sbin
    cp -a mount.unionfs $out/sbin/mount.unionfs-fuse
    substituteInPlace $out/sbin/mount.unionfs-fuse --replace mount.fuse ${fuse}/sbin/mount.fuse
    substituteInPlace $out/sbin/mount.unionfs-fuse --replace unionfs $out/bin/unionfs
  '';

  meta = {
    description = "FUSE UnionFS implementation";
    homepage = http://podgorny.cz/moin/UnionFsFuse;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = stdenv.lib.platforms.linux;
  };
}
