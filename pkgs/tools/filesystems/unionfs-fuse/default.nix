{ lib, stdenv, fetchFromGitHub, cmake, fuse }:

stdenv.mkDerivation rec {
  pname = "unionfs-fuse";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "rpodgorny";
    repo = "unionfs-fuse";
    rev = "v${version}";
    sha256 = "0bwx70x834qgqh53vqp18bhbxbsny80hz922rbgj8k9wj7cbfilm";
  };

  patches = [
    # Prevent the unionfs daemon from being killed during
    # shutdown. See
    # http://www.freedesktop.org/wiki/Software/systemd/RootStorageDaemons/
    # for details.
    ./prevent-kill-on-shutdown.patch
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace '/usr/local/include/osxfuse/fuse' '${fuse}/include/fuse'
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ fuse ];

  # Put the unionfs mount helper in place as mount.unionfs-fuse. This makes it
  # possible to do:
  #   mount -t unionfs-fuse none /dest -o dirs=/source1=RW,/source2=RO
  #
  # This must be done in preConfigure because the build process removes
  # helper from the source directory during the build.
  preConfigure = lib.optionalString (!stdenv.isDarwin) ''
    mkdir -p $out/sbin
    cp -a mount.unionfs $out/sbin/mount.unionfs-fuse
    substituteInPlace $out/sbin/mount.unionfs-fuse --replace mount.fuse ${fuse}/sbin/mount.fuse
    substituteInPlace $out/sbin/mount.unionfs-fuse --replace unionfs $out/bin/unionfs
  '';

  meta = with lib; {
    description = "FUSE UnionFS implementation";
    homepage = "https://github.com/rpodgorny/unionfs-fuse";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
