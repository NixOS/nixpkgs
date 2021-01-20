{ lib, stdenv, fetchFromGitHub
, python3, boost
, cmake
}:

stdenv.mkDerivation rec {
  pname = "trellis";
  version = "2021.01.02";

  # git describe --tags
  realVersion = with stdenv.lib; with builtins;
    "1.0-482-g${substring 0 7 (elemAt srcs 0).rev}";

  srcs = [
    (fetchFromGitHub {
       owner  = "SymbiFlow";
       repo   = "prjtrellis";
       rev    = "60c05b3f4e71fd78d4fba5c31f9974694245199e";
       sha256 = "1k37mxwxv9fpm6xnrxlqqap7zqh2dvgqncphj3asi2rz0kh07ppf";
       name   = "trellis";
     })

    (fetchFromGitHub {
      owner  = "SymbiFlow";
      repo   = "prjtrellis-db";
      rev    = "2cf058e7a3ba36134d21e34823e9b2ecaaceac2c";
      sha256 = "1hjaw5jkwiaiznm2z0smy88m2cdz63cd51z4nibajfih7ikvkj6g";
      name   = "trellis-database";
    })
  ];
  sourceRoot = "trellis";

  buildInputs = [ boost ];
  nativeBuildInputs = [ cmake python3 ];
  cmakeFlags = [
    "-DCURRENT_GIT_VERSION=${realVersion}"
    # TODO: should this be in stdenv instead?
    "-DCMAKE_INSTALL_DATADIR=${placeholder "out"}/share"
  ];

  preConfigure = with builtins; ''
    rmdir database && ln -sfv ${elemAt srcs 1} ./database

    source environment.sh
    cd libtrellis
  '';

  meta = with lib; {
    description     = "Documentation and bitstream tools for Lattice ECP5 FPGAs";
    longDescription = ''
      Project Trellis documents the Lattice ECP5 architecture
      to enable development of open-source tools. Its goal is
      to provide sufficient information to develop a free and
      open Verilog to bitstream toolchain for these devices.
    '';
    homepage    = "https://github.com/SymbiFlow/prjtrellis";
    license     = stdenv.lib.licenses.isc;
    maintainers = with maintainers; [ q3k thoughtpolice emily ];
    platforms   = stdenv.lib.platforms.all;
  };
}
