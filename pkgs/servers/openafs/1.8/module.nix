{ lib, stdenv, fetchurl, which, autoconf, automake, flex, bison
, kernel, glibc, perl, libtool_2, libkrb5, fetchpatch }:

with (import ./srcs.nix {
  inherit fetchurl;
});

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/extra/openafs";
  kernelBuildDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

in stdenv.mkDerivation {
  name = "openafs-${version}-${kernel.modDirVersion}";
  inherit version src;

  nativeBuildInputs = [ autoconf automake flex libtool_2 perl which bison ]
    ++ kernel.moduleBuildDependencies;

  buildInputs = [ libkrb5 ];

  patches = [
    # LINUX 5.14: explicitly set set_page_dirty to default
    ((fetchpatch {
      url = "https://gerrit.openafs.org/changes/14830/revisions/20b8a37950b3718b85a4a3d21b23469a5176eb6a/patch";
      sha256 = "1mkfwq0pbwvfjspsy2lxhi0f09hljgc6xyn3y97sai0dyivn05jp";
    }).overrideAttrs (o: {
      postFetch = "mv $out p; base64 -d p > $out; " + o.postFetch;
    }))
    # Linux 5.15: Convert osi_Msg macro to a function
    ((fetchpatch {
      url = "https://gerrit.openafs.org/changes/14831/revisions/6cfa9046229d90c0625687e3fddb7877f21fbcff/patch";
      sha256 = "18rip9a1krxf47fizf3f12ddq55apzb2w3wjj5qs7n3sh2nwks7g";
    }).overrideAttrs (o: {
      postFetch = "mv $out p; base64 -d p > $out; " + o.postFetch;
    }))
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
    maintainers = with maintainers; [ maggesi spacefrogg ];
    broken = versionOlder kernel.version "3.18" || kernel.isHardened;
  };
}
