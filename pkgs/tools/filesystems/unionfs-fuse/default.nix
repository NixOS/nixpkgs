{ stdenv, fetchFromGitHub, cmake, fuse }:

stdenv.mkDerivation rec {
  name = "unionfs-fuse-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "rpodgorny";
    repo = "unionfs-fuse";
    rev = "v${version}";
    sha256 = "0g2hd6yi6v8iqzmgncg1zi9a7ixy9hsh51rzf6jnmzi79543dihf";
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
    platforms = stdenv.lib.platforms.linux;
  };
}
