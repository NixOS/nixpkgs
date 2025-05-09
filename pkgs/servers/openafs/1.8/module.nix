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
