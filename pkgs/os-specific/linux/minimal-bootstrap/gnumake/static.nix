{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, gcc
, musl
, binutils
, gnumake
, gnupatch
, gnused
, gnugrep
, gawk
, diffutils
, findutils
, gnutar
, gzip
}:
let
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "gnumake-static";
  version = "4.4.1";

  src = fetchurl {
    url = "mirror://gnu/make/make-${version}.tar.gz";
    hash = "sha256-3Rb7HWe/q3mnL16DkHNcSePo5wtJRaFasfgd23hlj7M=";
  };

  patches = [
    # Replaces /bin/sh with sh, see patch file for reasoning
    ./0001-No-impure-bin-sh.patch
    # Purity: don't look for library dependencies (of the form `-lfoo') in /lib
    # and /usr/lib. It's a stupid feature anyway. Likewise, when searching for
    # included Makefiles, don't look in /usr/include and friends.
    ./0002-remove-impure-dirs.patch
  ];
in
bash.runCommand "${pname}-${version}" {
  inherit pname version meta;

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
    gzip
  ];

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/make --version
      mkdir $out
    '';
} ''
  # Unpack
  tar xf ${src}
  cd make-${version}

  # Patch
  ${lib.concatMapStringsSep "\n" (f: "patch -Np1 -i ${f}") patches}

  # Configure
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config} \
    CC=musl-gcc \
    CFLAGS=-static

  # Build
  make -j $NIX_BUILD_CORES

  # Install
  make -j $NIX_BUILD_CORES install
''
