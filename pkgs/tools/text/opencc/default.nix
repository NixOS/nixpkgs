{ lib, stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation rec {
  pname = "opencc";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "BYVoid";
    repo = "OpenCC";
    rev = "ver.${version}";
    sha256 = "1ygj2ygxsva72hs6cm0a6wdd2rp71k4nm0pd7cb20y2srdlzvdqk";
  };

  nativeBuildInputs = [ cmake python ];

  # let intermediate tools find intermediate library
  preBuild = lib.optionalString stdenv.isLinux ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$(pwd)/src
  '' + lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}$(pwd)/src
  '';

  # Parallel building occasionaly fails with: Error copying file "/tmp/nix-build-opencc-1.0.5.drv-0/OpenCC-ver.1.0.5/build/src/libopencc.so.1.0.0" to "/tmp/nix-build-opencc-1.0.5.drv-0/OpenCC-ver.1.0.5/build/src/tools".
  enableParallelBuilding = false;

  meta = with lib; {
    homepage = "https://github.com/BYVoid/OpenCC";
    license = licenses.asl20;
    description = "A project for conversion between Traditional and Simplified Chinese";
    longDescription = ''
      Open Chinese Convert (OpenCC) is an opensource project for conversion between
      Traditional Chinese and Simplified Chinese, supporting character-level conversion,
      phrase-level conversion, variant conversion and regional idioms among Mainland China,
      Taiwan and Hong kong.
    '';
    maintainers = with maintainers; [ sifmelcara ];
    platforms = with platforms; linux ++ darwin;
  };
}
