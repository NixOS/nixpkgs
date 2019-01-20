{ stdenv, fetchFromGitHub
, python3, boost
, cmake
}:

let
  boostWithPython3 = boost.override { python = python3; enablePython = true; };
in
stdenv.mkDerivation rec {
  name = "trellis-${version}";
  version = "2018.12.20";

  srcs = [
    (fetchFromGitHub {
       owner  = "symbiflow";
       repo   = "prjtrellis";
       rev    = "b947028a6ac6494b6000c6e1ab5aa0db813e8544";
       sha256 = "14dcsl2drx3xaqvpawp0j7088cijxcr5018yji48rmbl85763aw9";
       name   = "trellis";
     })
    (fetchFromGitHub {
      owner  = "symbiflow";
      repo   = "prjtrellis-db";
      rev    = "670d04f0b8412193d5e974eea67f2bb7355aa1ec";
      sha256 = "1hm385rg1jq9qbq63g5134gq9xpfadvpahxvzwpv0q543brkg730";
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
