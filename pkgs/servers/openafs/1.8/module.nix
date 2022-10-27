{ lib
, stdenv
, fetchurl
, which
, autoconf
, automake
, flex
, bison
, kernel
, glibc
, perl
, libtool_2
, libkrb5
, fetchpatch
}:

with (import ./srcs.nix {
  inherit fetchurl;
});

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/extra/openafs";
  kernelBuildDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  fetchBase64Patch = args: (fetchpatch args).overrideAttrs (o: {
    postFetch = "mv $out p; base64 -d p > $out; " + o.postFetch;
  });

in
stdenv.mkDerivation {
  pname = "openafs";
  version = "${version}-${kernel.modDirVersion}";
  inherit src;

  nativeBuildInputs = [ autoconf automake flex libtool_2 perl which bison ]
    ++ kernel.moduleBuildDependencies;

  buildInputs = [ libkrb5 ];

  patches = [
    # Import of code from autoconf-archive
    (fetchpatch {
      url = "https://git.openafs.org/?p=openafs.git;a=patch;h=d8205bbb482554812fbe66afa3c337d991a247b6";
      hash = "sha256-ohkjSux+S3+6slh6uZIw5UJXlvhy9UUDpDlP0YFRwmw=";
    })
    # Use autoconf-archive m4 from src/external
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/14944/revisions/ea2a0e128d71802f61b8da2e44de3c6325c5f328/patch";
      hash = "sha256-PAUk/MXL5p8xwhn40/UGmo3UIhvl1PB2FwgqhmqsjJ4=";
    })
    # cf: Use common macro to test compiler flags
    (fetchpatch {
      url = "https://git.openafs.org/?p=openafs.git;a=patch;h=790824ff749b6ee01c4d7101493cbe8773ef41c6";
      hash = "sha256-Zc7AjCsH7eTmZJWCrx7ci1tBjEAgcFXS9lY1YBeboLA=";
    })
    # Linux-5.17: kernel func complete_and_exit renamed
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/14945/revisions/a714e865efe41aa1112f6f9c8479112660dacd6f/patch";
      hash = "sha256-zvyR/GOPJeAbG6ySRRMp44oT5tPujUwybyU0XR/5Xyc=";
    })
    # Linux-5.17: Kernel build uses -Wcast-function-type
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/14946/revisions/449d1faf87e2841e80be38cf2b4a5cf5ff4df2d8/patch";
      hash = "sha256-3bRTHYeMRIleLhob56m2Xt0dWzIMDo3QrytY0K1/q7c=";
    })
    # afs: Introduce afs_IsDCacheFresh
    (fetchpatch {
      url = "https://git.openafs.org/?p=openafs.git;a=patch;h=0d8ce846ab2e6c45166a61f04eb3af271cbd27db";
      hash = "sha256-+xgRYVXz8XpT5c4Essc4VEn9Fj53vasAYhcFkK0oCBc=";
    })
    # LINUX: Don't panic on some file open errors
    (fetchpatch {
      url = "https://git.openafs.org/?p=openafs.git;a=patch;h=af73b9a3b1fc625694807287c0897391feaad52d";
      hash = "sha256-k0d+Gav1LApU24SaMI0pmR3gGfWyicqdCpTpVJLcx7U=";
    })
    # Linux-5.18 replace set_page_dirty with dirty_folio
    (fetchpatch {
      url = "https://git.openafs.org/?p=openafs.git;a=patch;h=6aa129e743e882cf30c35afd67eabf82274c5fca";
      hash = "sha256-8R0rdKYs7+Zl1sdizOZzpBjy6e9J+42R9HzsNUa/PQ4=";
    })
    # afs: introduce afs_alloc_ncr/afs_free_ncr
    (fetchpatch {
      url = "https://git.openafs.org/?p=openafs.git;a=patch;h=209eb92448001e59525413610356070d8e4f10a0";
      hash = "sha256-t455gTaK5U+m0qcyKjTqnWTOb4qz6VN/JYZzRAAV8kM=";
    })
    # afs: introduce get_dcache_readahead
    (fetchpatch {
      url = "https://git.openafs.org/?p=openafs.git;a=patch;h=44e24ae5d7dc41e54d23638d5f64ab2e81e43ad0";
      hash = "sha256-gtUNDSHAq+RY1Rm17YcxcUALy7FEBQf9k8/ELQlPORU=";
    })
    # Linux-5.18: replace readpages with readahead
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/14953/revisions/0497b0cd7bffb6335ab9bcbf5a1310b8c6a4b299/patch";
      hash = "sha256-a5pd+CHHPr1mGxsF7tSlaBqoiKw2IGr1mJ7EaDHDJSw=";
    })
  ];

  hardeningDisable = [ "pic" ];

  configureFlags = [
    "--with-linux-kernel-build=${kernelBuildDir}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-gssapi"
    "--disable-linux-d_splice-alias-extra-iput"
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
    maintainers = with maintainers; [ andersk maggesi spacefrogg ];
    broken = kernel.isHardened || kernel.kernelAtLeast "5.19";
  };
}
