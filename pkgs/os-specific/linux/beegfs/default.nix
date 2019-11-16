{ stdenv, fetchurl, pkgconfig, unzip, which
, libuuid, attr, xfsprogs, cppunit, rdma-core
, zlib, openssl, sqlite, jre, openjdk, ant
, openssh, perl, gfortran, influxdb, curl
} :

let
  version = "7.0";

  subdirs = [
    "beeond_thirdparty/build"
    "beeond_thirdparty_gpl/build"
    "thirdparty/build"
    "opentk_lib/build"
    "common/build"
    "admon/build"
    "java_lib/build"
    "ctl/build"
    "fsck/build"
    "helperd/build"
    "meta/build"
    "mgmtd/build"
    "storage/build"
    "utils/build"
    "mon/build"
    "upgrade/beegfs_mirror_md/build"
  ];

in stdenv.mkDerivation {
  pname = "beegfs";
  inherit version;

  src = fetchurl {
    url = "https://git.beegfs.com/pub/v7/repository/archive.tar.bz2?ref=${version}";
    sha256 = "1wsljd5ybyhl94aqrdfvcs8a0l8w4pr0bs1vhjrf4y7ldhw35m3k";
  };

  nativeBuildInputs = [ which unzip pkgconfig cppunit openjdk ant perl ];

  buildInputs = [
    libuuid
    attr
    xfsprogs
    zlib
    openssl
    sqlite
    jre
    rdma-core
    openssh
    gfortran
    influxdb
    curl
  ];

  hardeningDisable = [ "format" ]; # required for building beeond

  postPatch = ''
    patchShebangs ./
    find -type f -name Makefile -exec sed -i "s:/bin/bash:${stdenv.shell}:" \{} \;
    find -type f -name Makefile -exec sed -i "s:/bin/true:true:" \{} \;
    find -type f -name "*.mk" -exec sed -i "s:/bin/true:true:" \{} \;

    # unpack manually and patch variable name
    sed -i '/tar -C $(SOURCE_PATH) -xzf $(PCOPY_TAR)/d' beeond_thirdparty/build/Makefile
    cd beeond_thirdparty/source
    tar xf pcopy-0.96.tar.gz
    sed -i 's/\([^_]\)rank/\1grank/' pcopy-0.96/src/pcp.cpp
    cd ../..
  '';

  buildPhase = ''
    for i in ${toString subdirs}; do
      make -C $i BEEGFS_OPENTK_IBVERBS=1 ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES} -l''${NIX_BUILD_CORES}}
    done
    make -C admon/build admon_gui BEEGFS_OPENTK_IBVERBS=1
  '';

  enableParallelBuilding = true;

  installPhase = ''
    binDir=$out/bin
    docDir=$out/share/doc/beegfs
    includeDir=$out/include/beegfs
    libDir=$out/lib
    libDirPkg=$out/lib/beegfs

    mkdir -p $binDir $libDir $libDirPkg $docDir $includeDir

    cp admon/build/beegfs-admon $binDir
    cp admon/build/dist/usr/bin/beegfs-admon-gui $binDir
    cp admon_gui/dist/beegfs-admon-gui.jar $libDirPkg
    cp admon/build/dist/etc/beegfs-admon.conf $docDir

    cp java_lib/build/jbeegfs.jar $libDirPkg
    cp java_lib/build/libjbeegfs.so $libDir

    cp ctl/build/beegfs-ctl $binDir
    cp fsck/build/beegfs-fsck $binDir

    cp utils/scripts/beegfs-check-servers $binDir
    cp utils/scripts/beegfs-df $binDir
    cp utils/scripts/beegfs-net $binDir

    cp helperd/build/beegfs-helperd $binDir
    cp helperd/build/dist/etc/beegfs-helperd.conf $docDir

    cp client_module/build/dist/sbin/beegfs-setup-client $binDir
    cp client_module/build/dist/etc/beegfs-client.conf $docDir

    cp meta/build/beegfs-meta $binDir
    cp meta/build/dist/sbin/beegfs-setup-meta $binDir
    cp meta/build/dist/etc/beegfs-meta.conf $docDir

    cp mgmtd/build/beegfs-mgmtd $binDir
    cp mgmtd/build/dist/sbin/beegfs-setup-mgmtd $binDir
    cp mgmtd/build/dist/etc/beegfs-mgmtd.conf $docDir

    cp storage/build/beegfs-storage $binDir
    cp storage/build/dist/sbin/beegfs-setup-storage $binDir
    cp storage/build/dist/etc/beegfs-storage.conf $docDir

    cp opentk_lib/build/libbeegfs-opentk.so $libDir

    cp upgrade/beegfs_mirror_md/build/beegfs-mirror-md $binDir

    cp client_devel/build/dist/usr/share/doc/beegfs-client-devel/examples/* $docDir
    cp -r client_devel/include/* $includeDir

    cp beeond_thirdparty_gpl/build/parallel $out/bin
    cp beeond_thirdparty/build/pcopy/p* $out/bin
    cp beeond_thirdparty/build/pcopy/s* $out/bin
    cp -r beeond/scripts/* $out
    cp beeond/source/* $out/bin
  '';

  postFixup = ''
    substituteInPlace $out/bin/beegfs-admon-gui \
      --replace " java " " ${jre}/bin/java " \
      --replace "/opt/beegfs/beegfs-admon-gui/beegfs-admon-gui.jar" \
                "$libDirPkg/beegfs-admon-gui.jar"

    substituteInPlace $out/bin/beeond \
      --replace /opt/beegfs/sbin "$out/bin"
  '';

  doCheck = true;

  checkPhase = ''
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd`/opentk_lib/build/ \
      common/build/test-runner --text
  '';

  meta = with stdenv.lib; {
    description = "High performance distributed filesystem with RDMA support";
    homepage = "https://www.beegfs.io";
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = {
      fullName = "BeeGFS_EULA";
      url = "https://www.beegfs.io/docs/BeeGFS_EULA.txt";
      free = false;
    };
    maintainers = with maintainers; [ markuskowa ];
    # 2019-08-09
    # fails to build and had stability issues earlier
    broken = true;
  };
}
