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
    # Linux: mount_nodev removed, use new mount API
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16646/revisions/93db75395149e1f0dbdc3a0572f58449dd9da98d/patch";
      decode = "base64 -d";
      hash = "sha256-5eYliZV3WPjbQ3WGvZuqzeu060MHRof2yozSWPn+Njg=";
    })
    # Linux: Rename LINUX_WRITEPAGES_USES_FOLIOS
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16650/revisions/1e5801afe3069a9ca586c745ae1e26feb8f1048f/patch";
      decode = "base64 -d";
      hash = "sha256-qtqe64qhRwNBwfKkGhuEAKFDMFDirFxz9M0Wvtk+r1Q=";
    })
    # Linux: Don't use write_cache_pages for writepages
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16648/revisions/652674cec6c6c7349709dc080b6a2db3253424e6/patch";
      decode = "base64 -d";
      hash = "sha256-5T4hOge3U5uk3NSFxocYEjgfXU1Se5FkQk2rCRZDlfU=";
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
