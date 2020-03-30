{ stdenv, fetchFromGitHub
, python3, boost
, cmake
}:

let
  boostWithPython3 = boost.override { python = python3; enablePython = true; };
in
stdenv.mkDerivation rec {
  pname = "trellis";
  version = "2020.03.25";

  # git describe --tags
  realVersion = with stdenv.lib; with builtins;
    "1.0-152-g${substring 0 7 (elemAt srcs 0).rev}";

  srcs = [
    (fetchFromGitHub {
       owner  = "SymbiFlow";
       repo   = "prjtrellis";
       rev    = "c27bfc220a9f85f04173840d1ea081ba478adc9c";
       sha256 = "1fyl51246ns2njvij8g7k9a9axvhz8n8g09fny5dym9q7hcx08qh";
       name   = "trellis";
     })

    (fetchFromGitHub {
      owner  = "SymbiFlow";
      repo   = "prjtrellis-db";
      rev    = "c137076fdd8bfca3d2bf9cdacda9983dbbec599a";
      sha256 = "1br0vw8wwcn2qhs8kxkis5xqlr2nw7r3mf1qwjp8xckd6fa1wlcw";
      name   = "trellis-database";
    })
  ];
  sourceRoot = "trellis";

  buildInputs = [ boostWithPython3 ];
  nativeBuildInputs = [ cmake python3 ];
  cmakeFlags = [
    "-DCURRENT_GIT_VERSION=${realVersion}"
    # TODO: should this be in stdenv instead?
    "-DCMAKE_INSTALL_DATADIR=${placeholder "out"}/share"
  ];
  enableParallelBuilding = true;

  preConfigure = with builtins; ''
    rmdir database && ln -sfv ${elemAt srcs 1} ./database

    source environment.sh
    cd libtrellis
  '';

  meta = with stdenv.lib; {
    description     = "Documentation and bitstream tools for Lattice ECP5 FPGAs";
    longDescription = ''
      Project Trellis documents the Lattice ECP5 architecture
      to enable development of open-source tools. Its goal is
      to provide sufficient information to develop a free and
      open Verilog to bitstream toolchain for these devices.
    '';
    homepage    = https://github.com/SymbiFlow/prjtrellis;
    license     = stdenv.lib.licenses.isc;
    maintainers = with maintainers; [ q3k thoughtpolice emily ];
    platforms   = stdenv.lib.platforms.all;
  };
}
