{ stdenv, fetchFromGitHub
, python3, boost
, cmake
}:

let
  boostWithPython3 = boost.override { python = python3; enablePython = true; };
in
stdenv.mkDerivation rec {
  pname = "trellis";
  version = "2019.08.09";

  srcs = [
    (fetchFromGitHub {
       owner  = "symbiflow";
       repo   = "prjtrellis";
       rev    = "a67379179985bb12a611c75d975548cdf6e7d12e";
       sha256 = "0vqwfsblf7ylz0jnnf532kap5s1d1zcvbavxmb6a4v32b9xfdv35";
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
