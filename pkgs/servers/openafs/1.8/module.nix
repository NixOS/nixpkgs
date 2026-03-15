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
      url = "https://github.com/openafs/openafs/commit/8d1ccc2b22a63053a0f15bd432033ca57a2110e7.patch";
      hash = "sha256-6y0OLS6lAG+5NQU+PxcoF8VClpi+9IbnBzWCMIdMKuY=";
    })
    # LINUX: Re-dirty folio on writepages recursion
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/291a26a23bcf18b09f0c571d793273cc5e909123.patch";
      hash = "sha256-I1hnj6B2VZfu91QEIUwF1j9VOfntAfnzqg5uMtYf0TA=";
    })
    # Linux: Introduce LINUX_WRITE_CACHE_PAGES_USES_FOLIOS
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/5a2421f942ddee757093d9bba07d31c55610bc47.patch";
      hash = "sha256-SUJxhIL1vNDS8IO6GVGQ8aZOa6XabR3qFfTzWV6umao=";
    })
    # Linux: Avoid write_cache_pages() for ->writepages()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/030378b1f430c36de90208dbca55056e05bbb2e3.patch";
      hash = "sha256-B2HgkmNu/lQ4s4DLqQMAQpF0tjtxDE+PWi8hWhgaH48=";
    })
    # LINUX: Log warning on recursive folio writeback
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16697/revisions/e2ba1fc43292053eeedfd44338a7c6c0533030c7/patch";
      decode = "base64 -d";
      hash = "sha256-yXUmQ/yG98gsc16Qw2ATRGk+KdadpbNCtlUz4N3h5Ik=";
    })
    # Linux: Move afs_root()/afs_fill_super() in osi_vfsops
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16673/revisions/224ba63f0da6db3333b2342c0875b5e09135a89d/patch";
      decode = "base64 -d";
      hash = "sha256-5Dch/f9nXHk/wOV5Jb04SBzdR+Ek62eTEWZ5huJhpP8=";
    })
    # Linux: Use sockaddr_unsized for socket->ops->bind
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16683/revisions/98ac1d5964c0eb21416f59592c211b0fb7fd8a14/patch";
      decode = "base64 -d";
      hash = "sha256-lHRxDUIyFZNAvJ8J+4SfP9ETU/wnjGh6s5E+bmrQG08=";
    })
    # Linux: Pass 3rd parameter to filemap_alloc_folio()
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16684/revisions/8f8d0cd5763266763ef775a4f227ccec0a7bc3dd/patch";
      decode = "base64 -d";
      hash = "sha256-V4DMpB4nQJqWAsBbkLwz+M+/IrMIFpgz2CLDrAG1TKM=";
    })
    # Linux: implement aops->migrate_folio
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16689/revisions/b3724170294e2ab5c616cc0352ccb489de6a9280/patch";
      decode = "base64 -d";
      hash = "sha256-UTcV4TfLqCeU7zXE8KO8YE35sTvskSLz+/tOV2ZUhoY=";
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
