{ stdenv, fetchFromGitHub
, python3, boost
, cmake
}:

let
  boostWithPython3 = boost.override { python = python3; enablePython = true; };
in
stdenv.mkDerivation rec {
  name = "trellis-${version}";
  version = "2019.02.21";

  srcs = [
    (fetchFromGitHub {
       owner  = "symbiflow";
       repo   = "prjtrellis";
       rev    = "90910577671cdd950e56df6cb29d848dadea9467";
       sha256 = "0j5gnkqfkp8k01wmzsplg713dmw1zvg04hsy33bzbyxaqviybdip";
       name   = "trellis";
     })
    (fetchFromGitHub {
      owner  = "symbiflow";
      repo   = "prjtrellis-db";
      rev    = "d0b219af41ae3da6150645fbc5cc5613b530603f";
      sha256 = "1mnzvrqrcbfypvbagwyf6arv3kmj6q7n27gcmyk6ap2xnavkx4bq";
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
    maintainers = with maintainers; [ q3k thoughtpolice ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
