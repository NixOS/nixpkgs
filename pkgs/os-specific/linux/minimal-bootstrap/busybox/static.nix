{ lib
, fetchurl
, bash
, gcc
, musl
, binutils
, linux-headers
, gnumake
, gnupatch
, gnused
, gnugrep
, gawk
, diffutils
, findutils
, gnutar
, bzip2
}:
let
  pname = "busybox-static";
  version = "1.36.1";

  src = fetchurl {
    url = "https://busybox.net/downloads/busybox-${version}.tar.bz2";
    hash = "sha256-uMwkyVdNgJ5yecO+NJeVxdXOtv3xnKcJ+AzeUOR94xQ=";
  };

  patches = [
    ./busybox-in-store.patch
  ];

  busyboxConfig = [
    "CC=musl-gcc"
    "HOSTCC=musl-gcc"
    "CFLAGS=-I${linux-headers}/include"
    "KCONFIG_NOTIMESTAMP=y"
    "CONFIG_PREFIX=${placeholder "out"}"
    "CONFIG_STATIC=y"
  ];
in
bash.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [
    gcc
    musl
    binutils
    gnumake
    gnupatch
    gnused
    gnugrep
    gawk
    diffutils
    findutils
    gnutar
    bzip2
  ];

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}
      mkdir $out
    '';

  meta = with lib; {
    description = "Tiny versions of common UNIX utilities in a single small executable";
    homepage = "https://busybox.net/";
    license = licenses.gpl2Only;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.linux;
  };
} ''
  # Unpack
  tar xf ${src}
  cd busybox-${version}

  # Patch
  ${lib.concatMapStringsSep "\n" (f: "patch -Np1 -i ${f}") patches}

  # Configure
  BUSYBOX_FLAGS="${lib.concatStringsSep " " busyboxConfig}"
  make -j $NIX_BUILD_CORES $BUSYBOX_FLAGS defconfig

  # Build
  make -j $NIX_BUILD_CORES $BUSYBOX_FLAGS

  # Install
  cp busybox $out
''
