{ stdenv, fetchurl, fetchpatch, which
, kmod, kernel
} :

let
  version = "6.17";
in stdenv.mkDerivation {
  name = "beegfs-module-${version}-${kernel.version}";

  src = fetchurl {
    url = "https://git.beegfs.com/pub/v6/repository/archive.tar.bz2?ref=${version}";
    sha256 = "10xs7gzdmlg23k6zn1b7jij3lljn7rr1j6h476hq4lbg981qk3n3";
  };

  hardeningDisable = [ "fortify" "pic" "stackprotector" ];

  nativeBuildInputs = [ which kmod ];

  buildInputs = kernel.moduleBuildDependencies;

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build/" ];

  patches = [
    # upstream patch for linux 4.14 compatibility
    (fetchpatch {
      url = https://git.beegfs.io/pub/v6-nightly/commit/c54ab7e0714a85bf245e71d8b6c4e15d021c3e37.diff;
      sha256 = "1qzqnsvcl9km5z51vpsbvx5c9qrva4z09ka01nsjwxbr9mccmnx8";
    })
    # Fix a kernel oops during unmount introduced by 4.12
    (fetchpatch {
      url = https://git.beegfs.io/pub/v6-nightly/commit/0fe6a133f734183e4e21b9e8b4595593000791e7.diff;
      sha256 = "1pf54jjvdk1a5i7hjyqcn63vy7mqyly2s74lxvcqsf14klzviqc0";
    })
  ];

  postPatch = ''
    patchShebangs ./
    find -type f -name Makefile -exec sed -i "s:/bin/bash:${stdenv.shell}:" \{} \;
    find -type f -name Makefile -exec sed -i "s:/bin/true:true:" \{} \;
    find -type f -name "*.mk" -exec sed -i "s:/bin/true:true:" \{} \;
  '';

  preBuild = "cd beegfs_client_module/build";

  installPhase = ''
    instdir=$out/lib/modules/${kernel.modDirVersion}/extras/fs/beegfs
    mkdir -p $instdir
    cp beegfs.ko $instdir
  '';

  meta = with stdenv.lib; {
    description = "High performance distributed filesystem with RDMA support";
    homepage = "https://www.beegfs.io";
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = licenses.gpl2;
    maintainers = with maintainers; [ markuskowa ];
  };
}

