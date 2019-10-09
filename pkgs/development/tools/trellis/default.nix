{ stdenv, fetchFromGitHub
, python3, boost
, cmake
}:

let
  boostWithPython3 = boost.override { python = python3; enablePython = true; };
in
stdenv.mkDerivation rec {
  pname = "trellis";
  version = "2019.09.27";
  # git describe --tags
  realVersion = with stdenv.lib; with builtins;
    "1.0-71-g${substring 0 7 (elemAt srcs 0).rev}";

  srcs = [
    (fetchFromGitHub {
       owner  = "symbiflow";
       repo   = "prjtrellis";
       rev    = "06904938dfe8f52392e73f7c8b1e034327887c27";
       sha256 = "1yk13pipj7wp2mma0qcss4sa0wx8h60x0l0x9awh8g2iyk1y8nfw";
       name   = "trellis";
     })
    (fetchFromGitHub {
      owner  = "symbiflow";
      repo   = "prjtrellis-db";
      rev    = "b4d626b6402c131e9a035470ffe4cf33ccbe7986";
      sha256 = "0k26lq6c049ja8hhqcljwjb1y5k4gcici23l2n86gyp83jr03ilx";
      name   = "database";
    })
  ];
  sourceRoot = "trellis";

  buildInputs = [ boostWithPython3 ];
  nativeBuildInputs = [ cmake python3 ];
  cmakeFlags = [ "-DCURRENT_GIT_VERSION=${realVersion}" ];

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
    homepage    = https://github.com/symbiflow/prjtrellis;
    license     = stdenv.lib.licenses.isc;
    maintainers = with maintainers; [ q3k thoughtpolice emily ];
    platforms   = stdenv.lib.platforms.all;
  };
}
