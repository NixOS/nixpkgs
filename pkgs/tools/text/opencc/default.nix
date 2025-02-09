{ lib, stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "opencc";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "BYVoid";
    repo = "OpenCC";
    rev = "ver.${version}";
    sha256 = "sha256-N7nazA0xoQ2ewOGDiJg1vBBYMdF1/qiCfNjG5CFFbuk=";
  };

  nativeBuildInputs = [ cmake python3 ];

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
