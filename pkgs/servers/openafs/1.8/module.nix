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

  fetchBase64Patch = args: (fetchpatch args).overrideAttrs (o: {
    postFetch = "mv $out p; base64 -d p > $out; " + o.postFetch;
  });

in
stdenv.mkDerivation {
  pname = "openafs";
  version = "${version}-${kernel.modDirVersion}";
  inherit src;

  patches = [
    # Linux-6.10: Use filemap_alloc_folio when avail
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/0f6a3a402f4a66114da9231032bd68cdc4dee7bc.patch";
      hash = "sha256-1D0mijyF4hbd+xCONT50cd6T9eCpeM8Li3nCI7HgLPA=";
    })
    # Linux-6.10: define a wrapper for vmalloc
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/658942f2791fad5e33ec7542158c16dfc66eed39.patch";
      hash = "sha256-MhfAUX/eNOEkjO0cGVbnIdObMlGtLdCnnGfJECDwO+A=";
    })
    # Linux-6.10: remove includes for asm/ia32_unistd.h
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/03b280649f5e22ed74c217d7c98c3416a2fa9052.patch";
      hash = "sha256-ZdXz2ziuflqz7zNzjepuGvwDAPM31FIzsoEa4iNdLmo=";
    })
    # afs: avoid empty-body warning
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/d8b56f21994ce66d8daebb7d69e792f34c1a19ed.patch";
      hash = "sha256-10VUfZdZiOC8xSPM0nq8onqiv7X/Vv4/WwGlkqWkNkQ=";
    })
    # Linux 6.10: Move 'inline' before func return type
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/7097eec17bc01bcfc12c4d299136b2d3b94ec3d7.patch";
      hash = "sha256-PZmqeXWJL3EQFD9250YfDwCY1rvSGVCbAhzyHP1pE0Q=";
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
