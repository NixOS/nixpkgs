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
      url = "https://gerrit.openafs.org/changes/16276/revisions/c1d074317e5c8cb8212e0b19a29f7d710bcabb32/patch";
      decode = "base64 -d";
      hash = "sha256-8ga9ks9pr6pWaV2t67v+FaG0yVExhqELkvkpdLvO8Nc=";
    })
    # Linux-6.14: Handle dops.d_revalidate with parent
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16277/revisions/0051bd0ee82b05e8caacdc0596e5b62609bebd2e/patch";
      decode = "base64 -d";
      hash = "sha256-08jedwZ1KX1RSs8y9sh7BUvv5xK9tlzZ6uBOR4kS0Jo=";
    })
    # Linux: Add required MODULE_DESCRIPTION
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16372/revisions/39189eba45542376e668636bd79a93ae6a8a7cd2/patch";
      decode = "base64 -d";
      hash = "sha256-j5ckKQvybEvmlnFs5jX8g8Dfw37LYWGnfsl4hnZ3+A4=";
    })
    # linux: inode_ops mkdir returns struct dentry *
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16373/revisions/769847e205d5908a0c430f7bcfbd2f48e19f8bf8/patch";
      decode = "base64 -d";
      hash = "sha256-znv5gunyPnJgi4SRFERJudtYFqiS+AVYDWfvr52Ku3s=";
    })
    # Linux: Use __filemap_get_folio()
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16374/revisions/f187add554da9e9c52752edbfa98f486f683cf25/patch";
      decode = "base64 -d";
      hash = "sha256-+ay87ThSn6QyPZcN0+oE01Wqbxmz0Z1KXYwocQCvYLg=";
    })
    # Linux: Use folio_wait_locked()
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16375/revisions/87a93f6488585553d833e1397e7f0dae0545cb7e/patch";
      decode = "base64 -d";
      hash = "sha256-MOVX2LFe8OBnvsQ2UdLvwKrwztOmnu1rdIou4CF+EBs=";
    })
    # cf: Introduce AC_CHECK_LINUX_SYMBOL
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16376/revisions/bab5968d7f4639d4a0cbe81aaa3e9716dda00632/patch";
      decode = "base64 -d";
      hash = "sha256-d6DZqDTW1uEKSB5PsomS4ix9fYYQzdQVmDATKl6n7x4=";
    })
    # cf: check for dentry flag macros/enums
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16377/revisions/f791d8ca4804486c656bc7c221076480df39b465/patch";
      decode = "base64 -d";
      hash = "sha256-7B0VJE3FeSQU1ElvXI5zXCPq1JRLAycyhqIQuDdR7xE=";
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
  ] ++ kernel.moduleBuildDependencies;

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
