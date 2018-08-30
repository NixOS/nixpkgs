{ stdenv, fetchFromGitHub, python3, cmake, boost }:

let
  trellisdb = fetchFromGitHub {
    owner = "SymbiFlow";
    repo  = "prjtrellis-db";
    rev   = "06b429ddb7fd8ec1e3f2b35de2e94b4853cf2835";
    sha256 = "07bsgw5x3gq0jcn9j4g7q9xvibvz6j2arjnvgyrxnrg30ri9q173";
  };
in
stdenv.mkDerivation rec {
  name = "trellis-${version}";
  version = "2018.08.01";

  buildInputs = [
    (boost.override { python = python3; enablePython = true; })
  ];

  nativeBuildInputs = [
    cmake python3
  ];

  src = fetchFromGitHub {
    owner  = "SymbiFlow";
    repo   = "prjtrellis";
    rev    = "fff9532fe59bf9e38b44f029ce4a06c607a9ee78";
    sha256 = "0ycw9fjf6428sf5x8x5szn8fha79610nf7nn8kmibgmz9868yv30";
  };

  preConfigure = ''
    source environment.sh
    cp -RT "${trellisdb}" database
    cd libtrellis
  '';

  meta = {
    description = "Documentation and tools for Lattice ECP5 FPGAs";
    longDescription = ''
      Project Trellis documents the Lattice ECP5 architecture
      to enable development of open-source tools. Its goal is
      to provide sufficient information to develop a free and
      open Verilog to bitstream toolchain for these devices.
    '';
    homepage = https://github.com/SymbiFlow/prjtrellis;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ q3k ];
    platforms = stdenv.lib.platforms.linux;
  };
}
