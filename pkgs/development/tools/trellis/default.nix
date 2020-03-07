{ stdenv, fetchFromGitHub
, python3, boost
, cmake
}:

let
  boostWithPython3 = boost.override { python = python3; enablePython = true; };
in
stdenv.mkDerivation rec {
  pname = "trellis";
  version = "2020.02.04";
  # git describe --tags
  realVersion = with stdenv.lib; with builtins;
    "1.0-130-g${substring 0 7 (elemAt srcs 0).rev}";

  srcs = [
    (fetchFromGitHub {
       owner  = "SymbiFlow";
       repo   = "prjtrellis";
       rev    = "4e4b95c8e03583d48d76d1229f9c7825e2ee5be1";
       sha256 = "02kg48393bjiys56r62b4ks2xvfarw9phi5bips2xsnj9c99pmg0";
       name   = "trellis";
     })
    (fetchFromGitHub {
      owner  = "SymbiFlow";
      repo   = "prjtrellis-db";
      rev    = "717478b757a702bbc7e3e11a5fbecee2a64f7922";
      sha256 = "0q4j8qz3m2hissn2a82ck542cx62bp4f0wwzl3g22yv59i13yg83";
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
