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
    # Linux: Define Clear/Set PageError macros as NOPs
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/15964/revisions/917d071a1b3c3e23c984ca8e5501ddccd62a01b6/patch";
      decode = "base64 -d";
      hash = "sha256-WqAHRN1YZj7Cz4X4iF1K3DJC1h8nXlnA9gveClL3KHc=";
    })
    # Linux: Refactor afs_linux_write_begin() variants
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/15965/revisions/c955b666b904b96620df10328a9a37c2fb5f2ed6/patch";
      decode = "base64 -d";
      hash = "sha256-U2W+8YrD1K7Pb/Jq08uBcuPnGkVvcSyTpwaWWcTbq0w=";
    })
    # Linux: Use folios for aops->write_begin/end
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/15966/revisions/d1706bdc5080b86b1876d10f062c369e8d898188/patch";
      decode = "base64 -d";
      hash = "sha256-jY+r9LO/4g6K9J1stxNCa38nyr1/J3beOhG9YilEbzg=";
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
