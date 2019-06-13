{ stdenv, fetchurl, which
, kmod, kernel
} :

let
  version = "7.0";
in stdenv.mkDerivation {
  name = "beegfs-module-${version}-${kernel.version}";

  src = fetchurl {
    url = "https://git.beegfs.com/pub/v7/repository/archive.tar.bz2?ref=${version}";
    sha256 = "1wsljd5ybyhl94aqrdfvcs8a0l8w4pr0bs1vhjrf4y7ldhw35m3k";
  };

  hardeningDisable = [ "fortify" "pic" "stackprotector" ];

  nativeBuildInputs = [ which kmod ];

  buildInputs = kernel.moduleBuildDependencies;

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build/" ];

  postPatch = ''
    patchShebangs ./
    find -type f -name Makefile -exec sed -i "s:/bin/bash:${stdenv.shell}:" \{} \;
    find -type f -name Makefile -exec sed -i "s:/bin/true:true:" \{} \;
    find -type f -name "*.mk" -exec sed -i "s:/bin/true:true:" \{} \;
  '';

  preBuild = "cd client_module/build";

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
    broken = stdenv.lib.versionAtLeast kernel.version "4.18";
  };
}
