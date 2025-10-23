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
    # LINUX: Refactor afs_linux_dentry_revalidate()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/02603ec7bb2b6dadd9fc6f30f1d180732673f3d9.patch";
      hash = "sha256-A5fM6v/WMzl7Jj1liHaPYqlZRa2/q2rxj6H3r25VpXY=";
    })
    # Linux-6.14: Handle dops.d_revalidate with parent
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/5f85032cdb7f0148dc6165773acb6d6ffe4b6914.patch";
      hash = "sha256-08jedwZ1KX1RSs8y9sh7BUvv5xK9tlzZ6uBOR4kS0Jo=";
    })
    # Linux: Add required MODULE_DESCRIPTION
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/e76b520f1316e7059a7855078f117ce194734317.patch";
      hash = "sha256-B3h2XLaRL3jaFFKl2naydVedugVo25A2PEK4ds5WHJo=";
    })
    # linux: inode_ops mkdir returns struct dentry *
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/eeb4f7012ce8b22ff24d073e52e837ef36507afb.patch";
      hash = "sha256-2LqB2QGTMoE4Z7fcW4XZV/R9OzR6BI6pD99ODtKQHk8=";
    })
    # cf: check for dentry flag macros/enums
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/62e2df3182bea9ea7d5e86d4d3a0dfc955bc3753.patch";
      hash = "sha256-d8zRwt/Wq3UmI/hW033ZyzEP/6her/jspzGTfbunGxw=";
    })
    # Linux: Use folio_wait_locked()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/16070e998960f7fe0c15dfa13b88c7b1fa36dce2.patch";
      hash = "sha256-GbqXEviQJUqzEOpRtUHP2iM0Gx6+PYkflmMDAd21t/Y=";
    })
    # Linux: Refactor afs_linux_write_end()/begin()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/d946ce6f218a2013bc002fb44ad23b89f2d21212.patch";
      hash = "sha256-9JxMasRbpbdsdcwkJdaiIbNmqqC7VF++/Dl1WmsnRkg=";
    })
    # Linux: Use __filemap_get_folio()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/0c44e9f27fd0e058b59a9b63d755036829590e81.patch";
      hash = "sha256-9/anvdp/Pw6Iy4+FC6qTZUTZ318gh88jTr7uDDtu2+Q=";
    })
    # LINUX: Use folio_page() to convert folio to page
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/39ce8f11df2d650bb4d86c76c127c292880a5c76.patch";
      hash = "sha256-C0ESzTaYq2S41bcuz4Zkd35Sucw+8xrD0E9gx1lHeJ4=";
    })
    # LINUX: Remove test for DCACHE_NFSFS_RENAMED
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/78f5daf8bd79603c53630ba6eb712ab87ebc5dc5.patch";
      hash = "sha256-CwKp+8toPsKlagcN0r6uafGH0M2bcpFJMbMjd0FsRr8=";
    })
    # linux: change lookup_one_len to lookup_noperm
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/a580c6388ae08b8af0fa03d866f7db5e9c87a209.patch";
      hash = "sha256-9z0+GYTkv8sbXJpJ4wV9uBWT3Ebz9AKwDKAJa3Cd1zw=";
    })
    # linux: refactor afs_linux_writepage
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/691e90fa1c58d9afb2e26fe6b9022329364ac048.patch";
      hash = "sha256-r+dbeJsf7DQ6E0szm5PjpYKz4Ity2tcSxgub0aG9UsU=";
    })
    # Linux: Use __readahead_folio
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/c226a7073270f6f8669581dd31ce787905cc0ded.patch";
      hash = "sha256-OXA0iF7uITUZr5fymXF62XiZhaz3WHZqcvkg2hVTuTI=";
    })
    # Linux: Rename page->index to page->__folio_index
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/3e57d358defc12eb573331b2ca9940abedf93f4f.patch";
      hash = "sha256-J8d6u+7H1HW3xi1nQCEfLJihyLIaJVMvbxFAT++jdX8=";
    })
    # linux: convert aops->writepage to writepages
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/a31b416054f7e5de2188ecfb1e59fe7223921197.patch";
      hash = "sha256-RSXganheuV8GW0/KuwQyIwac4cBMgiNWc5u5oCfr5Wc=";
    })
    # Linux: Use struct kiocb * for aops write_begin/end
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16558/revisions/78c5beffaca71b226667ce558baf7be225093870/patch";
      decode = "base64 -d";
      hash = "sha256-Y6xPjNM0J1DpJ62stnEaB+mJsa9kq89TGMxZkIk9334=";
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

  meta = with lib; {
    description = "Open AFS client kernel module";
    homepage = "https://www.openafs.org";
    license = licenses.ipl10;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      andersk
      spacefrogg
    ];
    broken = kernel.isHardened;
  };
}
