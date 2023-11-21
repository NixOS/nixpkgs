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

  patches = [
    # cf: Fix cast-function-type err w/disable-checking
    (fetchpatch {
      url = "https://git.openafs.org?p=openafs.git;a=patch;h=6867a3e8429f37fb748575df52256227ae9e5b53";
      hash = "sha256-FDvOFDzl2eFN7ZKUqQBQSWGo0ntayc8NCYh/haVi8Ng=";
    })
    # LINUX: Make 'fs flush*' invalidate dentry
    (fetchpatch {
      url = "https://git.openafs.org?p=openafs.git;a=patch;h=898098e01e19970f80f60a0551252b2027246038";
      hash = "sha256-ehwRrzpqB8iJKuZ/18oJsrHVlKQs6EzCNaPtSG1m0sw=";
    })
    # Linux 6.5: Replace generic_file_splice_read
    (fetchpatch {
      url = "https://git.openafs.org?p=openafs.git;a=patch;h=fef245769366efe8694ddadd1e1f2ed5ef8608f4";
      hash = "sha256-TD1xYvlc9aJyravNZLPhceeOwBawvn0Ndxd50rszTJU=";
    })
    # LINUX: Make sysctl definitions more concise
    (fetchpatch {
      url = "https://git.openafs.org?p=openafs.git;a=patch;h=d15c7ab50c92671052cbe9a93b0440c81156d8aa";
      hash = "sha256-6K593AJvgC34RfnIqW8+0A/v9cF6tsbVMeKpCv+QrK4=";
    })
    # Linux 6.5: Use register_sysctl()
    (fetchpatch {
      url = "https://git.openafs.org?p=openafs.git;a=patch;h=63801cfd1fc06ec3259fcfd67229f3a3c70447ed";
      hash = "sha256-eoQxaZ28OanSoaHRJcfvXQORbe21YLhwPLoJUILjMkU=";
    })
    # hcrypto: rename abort to _afscrypto_abort
    (fetchpatch {
      url = "https://git.openafs.org?p=openafs.git;a=patch;h=538f450033a67e251b473ff92238b3124b85fc72";
      hash = "sha256-ztfJQKvGHGdWQe/0+BGkgRFxOi3n4YY+EFxgbD3DO1E=";
    })
    # cf: Avoid nested C functions built by autoconf
    (fetchpatch {
      url = "https://git.openafs.org?p=openafs.git;a=patch;h=d50ced2a17e05884ea18bb3dfcde6378b2531dc7";
      hash = "sha256-dK2/9bGhlXCPCB9t9T/K2dKdRBShVKXtYXWPttsOhAM=";
    })
    # cf: Use static allocated structs for cf tests
    (fetchpatch {
      url = "https://git.openafs.org?p=openafs.git;a=patch;h=00f13c45d637249a0d698458e08c1b8e2da8e219";
      hash = "sha256-YNszJIxBDIsl3RgBcHEpNtYIrNLC0tnSbIOQvX0oZ+s=";
    })
    # LINUX: Pass an array of structs to register_sysctl
    (fetchpatch {
      url = "https://git.openafs.org?p=openafs.git;a=patch;h=5b647bf17a878271e1ce9882e41663770ee73528";
      hash = "sha256-9o4cr/KORtanTfuKMAMAOvePB+vK579rR85rY+m8VNM=";
    })
    # linux: Replace fop iterate with fop iterate_shared
    (fetchpatch {
      url = "https://git.openafs.org?p=openafs.git;a=patch;h=6de0a646036283266e1d4aeb583e426005ca5ad4";
      hash = "sha256-cL3ByjUS3QU8fSbuN7ZEEKyjb+6TbbZL10UKbSgNl6c=";
    })
    # Linux 6.6: convert to ctime accessor functions
    (fetchpatch {
      url = "https://git.openafs.org?p=openafs.git;a=patch;h=6413fdbc913834f2884989e5811841f4ccea2b5f";
      hash = "sha256-vdK25vfS5Yr0xQufzUk431FXHwMIWlP2UpLjqnobJWI=";
    })
    # Linux 6.6: Pass request_mask to generic_fillattr
    (fetchpatch {
      url = "https://git.openafs.org?p=openafs.git;a=patch;h=4f1d8104d17d2b4e95c7abaf5498db6b80aefa8f";
      hash = "sha256-XJpqbDB/LOuqZj3gPHlcLeGzAQCGvPH8ArgWf+sbBJU=";
    })
  ];

  nativeBuildInputs = [ autoconf automake flex libtool_2 perl which bison ]
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
    maintainers = with maintainers; [ andersk maggesi spacefrogg ];
    broken = kernel.isHardened;
  };
}
