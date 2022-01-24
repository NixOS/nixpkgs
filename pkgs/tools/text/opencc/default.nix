{ lib, stdenv, fetchFromGitHub, cmake, python2 }:

stdenv.mkDerivation rec {
  pname = "opencc";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "BYVoid";
    repo = "OpenCC";
    rev = "ver.${version}";
    sha256 = "sha256-q/y4tRov/BYCAiE4i7fT6ysTerxxOHMZUWT2Jlo/0rI=";
  };

  nativeBuildInputs = [ cmake python2 ];

  # let intermediate tools find intermediate library
  preBuild = lib.optionalString stdenv.isLinux ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$(pwd)/src
  '' + lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}$(pwd)/src
  '';

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
