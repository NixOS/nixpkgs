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
    # Linux: Use get_tree_nodev
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/c02a8f451b48766aa163e729abe40d145751b2dc.patch";
      hash = "sha256-9okSQLV4tW1wjoffQXPneZbu6tTRqrqVPbEOwZmaD+E=";
    })
    # LINUX: Re-dirty folio on writepages recursion
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/11849e96820eca64d91742a8c521614e1e99d9fa.patch";
      hash = "sha256-F2MOqEDaj4e0Xj1mvs7v61cutZY3cO22p9iIp2bLiRQ=";
    })
    # Linux: Introduce LINUX_WRITE_CACHE_PAGES_USES_FOLIOS
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/63a3503240c06187fa87514e5ea421cece483422.patch";
      hash = "sha256-ZWV8IZ8CeFQaEOamqKfkXuUccSxCRFNkZ7/kxKbEuis=";
    })
    # Linux: Avoid write_cache_pages() for ->writepages()
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16704/revisions/d465a07a98c2b0b2c23780571a8fe70c2584473a/patch";
      decode = "base64 -d";
      hash = "sha256-2FOf+o36gbTHm90RxtOI7iXcgb6rv9nh9rSjZzL5O7A=";
    })
    # LINUX: Log warning on recursive folio writeback
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16705/revisions/d66ca6372461840c6ecaaa46ec293640c8f22573/patch";
      decode = "base64 -d";
      hash = "sha256-A383wDMkwnGFatBDHUGV8FVqPMjzvhqUnIWrP2C+ym4=";
    })
    # Linux: Move afs_root()/afs_fill_super() in osi_vfsops
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16706/revisions/988c70859f1d402022e9342e28f0c5a954760a72/patch";
      decode = "base64 -d";
      hash = "sha256-JsZwGGa7dRT43RIUUY3hYCbbqPObd5bkDOHl9QK/MhE=";
    })
    # Linux: Use sockaddr_unsized for socket->ops->bind
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16707/revisions/e6069d6c35e848b5b388f4c47a2ecf0d72420198/patch";
      decode = "base64 -d";
      hash = "sha256-hTRaTqOc0njW/RIsNTrFZ5uWTrQq04Fuh/Sk7K2Q5e4=";
    })
    # Linux: Pass 3rd parameter to filemap_alloc_folio()
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16708/revisions/48d2184ec95418cada68b70919b0afd9888bb945/patch";
      decode = "base64 -d";
      hash = "sha256-CSGlXYkkLSHQoWK2xLpUYJDOUP/mlsxkTru2qdmbeQo=";
    })
    # Linux: implement aops->migrate_folio
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16709/revisions/2c51471aea08cc495a5d59fee6e651ba58c9d772/patch";
      decode = "base64 -d";
      hash = "sha256-TtcblVczSp8b1bfd0ajWjK2LffAkgYr2+KUL2nEe8hs=";
    })
    # Linux: Use set_default_d_op() to set dentry ops
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16729/revisions/6d0a2107fcab28fc4ba64d365133d171b75bd3dc/patch";
      decode = "base64 -d";
      hash = "sha256-OKxR5zzVKSXPzudPl5jc7koObisQMMqq/d9kfrMem/M=";
    })
    # Linux: Use __getname()/__putname() to alloc name
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16738/revisions/a1754489f382aabd087f14c325d13a36faa5bf5c/patch";
      decode = "base64 -d";
      hash = "sha256-JizLrwnujybCkcbDIltGfgVtCc5fL3ZxWvgVbI1kKto=";
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
  };
}
