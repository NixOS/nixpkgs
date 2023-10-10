{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, gcc
, musl
, binutils
, gnumake
, gnused
, gnugrep
, gawk
, diffutils
, findutils
, gnutar
, gzip
}:
let
  pname = "patchelf-static";
  version = "0.18.0";

  src = fetchurl {
    url = "https://github.com/NixOS/patchelf/releases/download/${version}/patchelf-${version}.tar.gz";
    sha256 = "sha256-ZN4Q5Ma4uDedt+h/WAMPM26nR8BRXzgRMugQ2/hKhuc=";
  };
in
bash.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [
    gcc
    musl
    binutils
    gnumake
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
      ${result}/bin/patchelf --version
      mkdir $out
    '';

  meta = with lib; {
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    homepage = "https://github.com/NixOS/patchelf";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
  # Unpack
  tar xf ${src}
  cd patchelf-${version}

  # Configure
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config} \
    CC=musl-gcc \
    CXXFLAGS=-static

  # Build
  make -j $NIX_BUILD_CORES

  # Install
  make -j $NIX_BUILD_CORES install-strip
''
