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
