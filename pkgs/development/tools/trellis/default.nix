{ stdenv, fetchFromGitHub
, python3, boost
, cmake
}:

let
  boostWithPython3 = boost.override { python = python3; enablePython = true; };
in
stdenv.mkDerivation rec {
  pname = "trellis";
  version = "2019.10.13";
  # git describe --tags
  realVersion = with stdenv.lib; with builtins;
    "1.0-95-g${substring 0 7 (elemAt srcs 0).rev}";

  srcs = [
    (fetchFromGitHub {
       owner  = "SymbiFlow";
       repo   = "prjtrellis";
       rev    = "e2e10bfdfaa29fed5d19e83dc7460be9880f5af4";
       sha256 = "0l59nliv75rdxnajl2plilib0r0bzbr3qqzc88cdal841x1m0izs";
       name   = "trellis";
     })
    (fetchFromGitHub {
      owner  = "SymbiFlow";
      repo   = "prjtrellis-db";
      rev    = "5b5bb70bae13e6b8c971b4b2d26931f4a64b51bc";
      sha256 = "1fi963zdny3gxdvq564037qs22i7b4y7mxc3yij2a1ww8rzrnpdj";
      name   = "trellis-database";
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
