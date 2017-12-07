{ stdenv, fetchFromGitHub, cmake, fuse }:

stdenv.mkDerivation rec {
  name = "unionfs-fuse-${version}";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "rpodgorny";
    repo = "unionfs-fuse";
    rev = "v${version}";
    sha256 = "0lb8zgdxnjy2fjr2284hvdfn7inc1in44ynzgcr66x54bxzvynj6";
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

  meta = with stdenv.lib; {
    description = "FUSE UnionFS implementation";
    homepage = https://github.com/rpodgorny/unionfs-fuse;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
