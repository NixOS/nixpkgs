{ stdenv, fetchFromGitHub
, python3, boost
, cmake
}:

let
  boostWithPython3 = boost.override { python = python3; enablePython = true; };
in
stdenv.mkDerivation rec {
  pname = "trellis";
  version = "2019.09.01";
  realVersion = with stdenv.lib; with builtins;
    "1.0-53-g${substring 0 7 (elemAt srcs 0).rev}";

  srcs = [
    (fetchFromGitHub {
       owner  = "symbiflow";
       repo   = "prjtrellis";
       rev    = "98871e0e2959bc8cb4de3c7ebe2b9eddc4efe00c";
       sha256 = "1yq7ih2xvhfvdpijmbqjq6jcngl6710kiv66hkww5ih8j5dzsq5l";
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
    substituteInPlace libtrellis/CMakeLists.txt \
      --replace "git describe --tags" "echo ${realVersion}"

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
