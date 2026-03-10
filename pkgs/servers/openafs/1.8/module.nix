{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  which,
  autoconf,
  automake,
  flex,
  bison,
  kernel,
  glibc,
  perl,
  libtool_2,
  libkrb5,
}:

let
  inherit (import ./srcs.nix { inherit fetchurl; }) src version;

  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/extra/openafs";
  kernelBuildDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

in
stdenv.mkDerivation {
  pname = "openafs";
  version = "${version}-${kernel.modDirVersion}";
  inherit src;

  patches = [
    # Linux: Use struct kiocb * for aops write_begin/end
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/a765a9ddd412c8d1e5cb0f5cf497a8606251811e.patch";
      hash = "sha256-RkIAdXMvelnWs4YB3OMj6AIQlUbSqdKJpwc6wiSZzrM=";
    })
    # linux: remove implied def HAVE_LINUX_FILEMAP_GET_FOLIO
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/c379ff006d8b7db425f7648321c549ab24919d92.patch";
      hash = "sha256-fDtX3NhWIWupTArEauCM2rEaO3l8jWBVC5mAMil2+nU=";
    })
    # LINUX: Zero code on EEXIST in afs_linux_read_cache
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/eb6753d93b930ad7d65772a9751117f6969a5e92.patch";
      hash = "sha256-97/MdG9DrHEtOKCRLCTgl6ZEtqLUsaNs9LcAzcyrTF4=";
    })
    # Linux: Use get_tree_nodev
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16646/revisions/d8202bcd24c90cfef138e54264355d242d8f2f2a/patch";
      decode = "base64 -d";
      hash = "sha256-lj7tRCrgWFPFsd5cMg9CQAFOx3VYUf3fS4JGNyAgnWk=";
    })
    # Linux: Introduce LINUX_WRITE_CACHE_PAGES_USES_FOLIOS
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16650/revisions/cef9524c481520040dc93a02f5df9cd9eb8907a2/patch";
      decode = "base64 -d";
      hash = "sha256-SUJxhIL1vNDS8IO6GVGQ8aZOa6XabR3qFfTzWV6umao=";
    })
    # Linux: Avoid write_cache_pages() for ->writepages()
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16648/revisions/dd83364354692eaa323b246df17fec2a3f11057d/patch";
      decode = "base64 -d";
      hash = "sha256-3hPqwfkpRkS/XXmWjl+zy4KmVL8RkBuhmC+O0D/h85U=";
    })
    # Linux: Move afs_root()/afs_fill_super() in osi_vfsops
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16673/revisions/dfd3e87daf227884fa0da7bbab83db1b9de9b882/patch";
      decode = "base64 -d";
      hash = "sha256-mWv/C5Yus4EZFrsQObCiOGA3nO2DAl1JWm8+YMHaabA=";
    })
    # Linux: Use sockaddr_unsized for socket->ops->bind
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16683/revisions/1a5864a5ff777142de3110a6e7848fd5769f933a/patch";
      decode = "base64 -d";
      hash = "sha256-lHRxDUIyFZNAvJ8J+4SfP9ETU/wnjGh6s5E+bmrQG08=";
    })
    # Linux: Pass 3rd parameter to filemap_alloc_folio()
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16684/revisions/870e0aeb9d6f26a814ee38ce1becf12b562b7fa1/patch";
      decode = "base64 -d";
      hash = "sha256-DZfi6OK9TYovwmYNrgI+WxGS13cQjdGODlSn3rQO/Gk=";
    })
    # Linux: implement aops->migrate_folio
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16689/revisions/6d294581969039eea65c974c3a8c565917df9c6a/patch";
      decode = "base64 -d";
      hash = "sha256-XXzrDfoG4BbEDp6C4TElN0+3ytTu4VP5goDiZlq8DjU=";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    flex
    libtool_2
    perl
    which
    bison
  ]
  ++ kernel.moduleBuildDependencies;

  buildInputs = [ libkrb5 ];

  hardeningDisable = [ "pic" ];

  configureFlags = [
    "--with-linux-kernel-build=${kernelBuildDir}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-gssapi"
  ];

  preConfigure = ''
    patchShebangs .
    for i in `grep -l -R '/usr/\(include\|src\)' .`; do
      echo "Patch /usr/include and /usr/src in $i"
      substituteInPlace $i \
        --replace "/usr/include" "${glibc.dev}/include" \
        --replace "/usr/src" "${kernelBuildDir}"
    done

    ./regen.sh -q
  '';

  buildPhase = ''
    make V=1 only_libafs
  '';

  installPhase = ''
    mkdir -p ${modDestDir}
    cp src/libafs/MODLOAD-*/libafs-${kernel.modDirVersion}.* ${modDestDir}/libafs.ko
    xz -f ${modDestDir}/libafs.ko
  '';

  meta = {
    description = "Open AFS client kernel module";
    homepage = "https://www.openafs.org";
    license = lib.licenses.ipl10;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      andersk
      spacefrogg
    ];
    broken = kernel.isHardened;
  };
}
