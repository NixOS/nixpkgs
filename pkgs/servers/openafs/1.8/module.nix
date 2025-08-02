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
      url = "https://gerrit.openafs.org/changes/16435/revisions/d3c424dcaba6ed8415a7617f0ae3622fe84e988a/patch";
      decode = "base64 -d";
      hash = "sha256-AqLhS6A68E5M+3CyNnIgv7CB5jGC/hQ4PIqPv0zggq4=";
    })
    # linux: refactor afs_linux_writepage
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16436/revisions/1f488463969b436a882c656020d1f3b92c6df440/patch";
      decode = "base64 -d";
      hash = "sha256-Wx8Xx97Kox76sSFOdpqxjMzXFrA2IFqKptpYEsfRTac=";
    })
    # linux: convert aops->writepage to writepages
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16437/revisions/fd33425820589ed52dc712df63ea8d4b5944de87/patch";
      decode = "base64 -d";
      hash = "sha256-B011gge+vzGeUxkGOkKoK/jZn16pvGGc8DpAzzbjV+8=";
    })
    # Linux: Use __readahead_folio
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16438/revisions/8a2cbf0ba08097de4b8ab0c57fe2fddf83739b9b/patch";
      decode = "base64 -d";
      hash = "sha256-MDb7vOekq/lwBgELMq+VfuvAXiHQmd0vp04ToqIm3lI=";
    })
    # Linux: Rename page->index to page->__folio_index
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16439/revisions/9a5596a25618f153be7ae7eb17f29f3b7752d863/patch";
      decode = "base64 -d";
      hash = "sha256-OYlMcmnIkoC841E0ONNWtSCUKokyxOmd0d+AWcXwbAI=";
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
      maggesi
      spacefrogg
    ];
    broken = kernel.isHardened;
  };
}
