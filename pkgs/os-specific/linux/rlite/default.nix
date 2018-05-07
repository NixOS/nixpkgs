{ stdenv, fetchFromGitHub, zlib, protobuf
, pkgconfig, libtool, cmake, which
, python3Packages, swig
 }:

with (import ./srcs.nix { inherit stdenv fetchFromGitHub; });

let
  inherit (python3Packages) wrapPython python;

in stdenv.mkDerivation rec {
  name = "rlite-${version}";
  inherit version src prePatch meta;

  # outputs = [ "bin" "lib" "python" "dev" "out" ];

  nativeBuildInputs = [ which cmake pkgconfig libtool swig wrapPython ];
  buildInputs = [ zlib protobuf python ];

  preConfigure = ''
    ${stdenv.shell} ./configure --no-kernel --prefix $out
  '';
  postFixup = "wrapPythonPrograms";

  # # split into multiple outputs
  # postInstall = ''
  #   echo "Splitting package outputs
  #   mkdir -p $bin $lib $python/lib $dev
  #   mv $out/bin $bin
  #   mv $out/lib/python* $python/lib
  #   mv $out/lib $lib
  #   mv $out/include $dev
  # '';

  # code won't build with -Werror=unused-result
  NIX_CFLAGS_COMPILE = "-w";
}
