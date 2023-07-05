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
    # LINUX: Run the 'sparse' checker if available
    (fetchpatch {
      url = "https://git.openafs.org/?p=openafs.git;a=patch;h=2cf76b31ce4c912b1151c141818f6e8c5cddcab2";
      hash = "sha256-//7HSlotx70vWDEMB8P8or4ZmmXZthgioUOkvOcJpgk=";
    })
    # cf: Detect how to pass CFLAGS to linux kbuild
    (fetchpatch {
      url = "https://git.openafs.org/?p=openafs.git;a=patch;h=57df4dff496ca9bea04510759b8fdd9cd2cc0009";
      hash = "sha256-pJnW9bVz2ZQZUvZ+PcZ5gEgCL5kcbTGxsyMNvM2IseU=";
    })
    # cf: Handle autoconf linux checks with -Werror
    (fetchpatch {
      url = "https://git.openafs.org/?p=openafs.git;a=patch;h=b17625959386459059f6f43875d8817383554481";
      hash = "sha256-Kqx5QEX1p4UoIsWxqvJVX4IyCQFiWxtAOgvAtk+ULuQ=";
    })
    # Linux: Fix functions without prototypes
    (fetchpatch {
      url = "https://git.openafs.org/?p=openafs.git;a=patch;h=3084117f10bd62acb1182cb54fc85b1d96738f70";
      hash = "sha256-nNyqDQfS9zzlS2i3dbfud2tQOaTQ1x/rZcQEsaLu3qc=";
    })
    # Linux: Check for block_dirty_folio
    (fetchpatch {
      url = "https://git.openafs.org/?p=openafs.git;a=patch;h=f0fee2c7752d18ff183d60bcfba4c98c3348cd5f";
      hash = "sha256-tnNlVjZ5exC+jo78HC/y8yp0L8KQroFvVRzTC+O6vlY=";
    })
    # Linux: Replace lru_cache_add with folio_add_lru
    (fetchpatch {
      url = "https://git.openafs.org/?p=openafs.git;a=patch;h=b885159cc2bc6c746aec1d54cdd8a515d1115d14";
      hash = "sha256-ptPALSbZPSGu8PMmZiOkHUd5x0UItqIM7U7wJlxtSL8=";
    })
    # LINUX 5.13: set .proc_lseek in proc_ops
    (fetchpatch {
      url = "https://git.openafs.org/?p=openafs.git;a=patch;h=cba2b88851c3ae0ab1b18ea3ce77f7f5e8200b2f";
      hash = "sha256-suj7n0U0odHXZHLPqeB/k96gyBh52uoS3AuHvOzPyd8=";
    })
    # Linux 6.3: Include linux/filelock.h if available
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15388/revisions/ddb99d32012c43c76ae37f6a7563f1ca32f0e964/patch";
      hash = "sha256-0Cql4+0ISfW4J4D7PhlSYNfIKAeDVWEz57PHOu5TRXg=";
    })
    # Linux 6.3: Use mnt_idmap for inode op functions
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15389/revisions/ff0d53d2fb38fc3b262f02fb1c5f49b286ff13dd/patch";
      hash = "sha256-KyVAI/A+/lNrLyKY6O8DgMKzgnF6P5sOfSq3qcs6Qq0=";
    })
  ];

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
    maintainers = with maintainers; [ andersk maggesi spacefrogg ];
    broken = kernel.isHardened;
  };
}
