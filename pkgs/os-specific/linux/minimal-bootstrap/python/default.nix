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
, xz
, zlib
}:
let
  pname = "python";
  version = "3.12.0";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/${version}/Python-${version}.tar.xz";
    hash = "sha256-eVw09E30Wg6blxDIxxwVxnGHFSTNQSyhTe8hLozLFV0=";
  };

  patches = [
    # Disable the use of ldconfig in ctypes.util.find_library (since
    # ldconfig doesn't work on NixOS), and don't use
    # ctypes.util.find_library during the loading of the uuid module
    # (since it will do a futile invocation of gcc (!) to find
    # libuuid, slowing down program startup a lot).
    ./no-ldconfig.patch
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
    xz
  ];

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/python3 --version
      mkdir $out
    '';

  meta = with lib; {
    description = "A high-level dynamically-typed programming language";
    homepage = "https://www.python.org";
    license = licenses.psfl;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.linux;
  };
} ''
  # Unpack
  tar xf ${src}
  cd Python-${version}

  # Patch
  ${lib.concatMapStringsSep "\n" (f: "patch -Np1 -i ${f}") patches}

  # Configure
  export CC=musl-gcc
  export C_INCLUDE_PATH="${zlib}/include"
  export LIBRARY_PATH="${zlib}/lib"
  export LD_LIBRARY_PATH="$LIBRARY_PATH"
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config}

  # Build
  make -j $NIX_BUILD_CORES

  # Install
  make -j $NIX_BUILD_CORES install
''
