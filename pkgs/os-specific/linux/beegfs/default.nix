{ stdenv, fetchurl, pkgconfig, unzip, which
, libuuid, attr, xfsprogs, cppunit, rdma-core
, zlib, openssl, sqlite, jre, openjdk, ant
, openssh, perl, gfortran
} :

let
  version = "6.18";

  subdirs = [
    "beeond_thirdparty/build"
    "beeond_thirdparty_gpl/build"
    "beegfs_thirdparty/build"
    "beegfs_opentk_lib/build"
    "beegfs_common/build"
    "beegfs_admon/build"
    "beegfs_java_lib/build"
    "beegfs_ctl/build"
    "beegfs_fsck/build"
    "beegfs_helperd/build"
    "beegfs_meta/build"
    "beegfs_mgmtd/build"
    "beegfs_online_cfg/build"
    "beegfs_storage/build"
    "beegfs_utils/build"
  ];

in stdenv.mkDerivation rec {
  name = "beegfs-${version}";

  src = fetchurl {
    url = "https://git.beegfs.com/pub/v6/repository/archive.tar.bz2?ref=${version}";
    sha256 = "1g874qyxh4v53ah3lzchrqi0jci7wngr54q3f4d9q0kzvvifripn";
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
    gfortran ];

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
      make -C $i BEEGFS_OPENTK_IBVERBS=1
    done
    make -C beegfs_admon/build admon_gui BEEGFS_OPENTK_IBVERBS=1
  '';

  installPhase = ''
    binDir=$out/bin
    docDir=$out/share/doc/beegfs
    includeDir=$out/include/beegfs
    libDir=$out/lib
    libDirPkg=$out/lib/beegfs

    mkdir -p $binDir $libDir $libDirPkg $docDir $includeDir

    cp beegfs_admon/build/beegfs-admon $binDir
    cp beegfs_admon/build/dist/usr/bin/beegfs-admon-gui $binDir
    cp beegfs_admon_gui/dist/beegfs-admon-gui.jar $libDirPkg
    cp beegfs_admon/build/dist/etc/beegfs-admon.conf $docDir

    cp beegfs_java_lib/build/jbeegfs.jar $libDirPkg
    cp beegfs_java_lib/build/libjbeegfs.so $libDir

    cp beegfs_ctl/build/beegfs-ctl $binDir
    cp beegfs_fsck/build/beegfs-fsck $binDir

    cp beegfs_utils/scripts/beegfs-check-servers $binDir
    cp beegfs_utils/scripts/beegfs-df $binDir
    cp beegfs_utils/scripts/beegfs-net $binDir

    cp beegfs_helperd/build/beegfs-helperd $binDir
    cp beegfs_helperd/build/dist/etc/beegfs-helperd.conf $docDir

    cp beegfs_client_module/build/dist/sbin/beegfs-setup-client $binDir
    cp beegfs_client_module/build/dist/etc/beegfs-client.conf $docDir

    cp beegfs_meta/build/beegfs-meta $binDir
    cp beegfs_meta/build/dist/sbin/beegfs-setup-meta $binDir
    cp beegfs_meta/build/dist/etc/beegfs-meta.conf $docDir

    cp beegfs_mgmtd/build/beegfs-mgmtd $binDir
    cp beegfs_mgmtd/build/dist/sbin/beegfs-setup-mgmtd $binDir
    cp beegfs_mgmtd/build/dist/etc/beegfs-mgmtd.conf $docDir

    cp beegfs_storage/build/beegfs-storage $binDir
    cp beegfs_storage/build/dist/sbin/beegfs-setup-storage $binDir
    cp beegfs_storage/build/dist/etc/beegfs-storage.conf $docDir

    cp beegfs_opentk_lib/build/libbeegfs-opentk.so $libDir

    cp beegfs_client_devel/build/dist/usr/share/doc/beegfs-client-devel/examples/* $docDir
    cp -r beegfs_client_devel/include/* $includeDir

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
    beegfs_common/build/test-runner --text
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
  };
}
