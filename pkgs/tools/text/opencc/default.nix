{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  opencc,
}:

stdenv.mkDerivation rec {
  pname = "opencc";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "BYVoid";
    repo = "OpenCC";
    rev = "ver.${version}";
    sha256 = "sha256-JKudwA2C7gHihjPnsqPq5i7X8TvG8yQYZEG5f/xu3yo=";
  };

  nativeBuildInputs =
    [
      cmake
      python3
    ]
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      opencc # opencc_dict
    ];

  meta = with lib; {
    homepage = "https://github.com/BYVoid/OpenCC";
    license = licenses.asl20;
    description = "Project for conversion between Traditional and Simplified Chinese";
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
