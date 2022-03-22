{ lib, stdenv, fetchFromGitHub, cmake, libtiff, pkg-config, tesseract }:

stdenv.mkDerivation rec {
  pname = "vobsub2srt";
  version = "unstable-2014-08-17";

  src = fetchFromGitHub {
    owner = "ruediger";
    repo = "VobSub2SRT";
    rev = "a6abbd61127a6392d420bbbebdf7612608c943c2";
    sha256 = "sha256-i6V2Owb8GcTcWowgb/BmdupOSFsYiCF2SbC9hXa26uY=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libtiff ];
  propagatedBuildInputs = [ tesseract ];

  meta = {
    homepage = "https://github.com/ruediger/VobSub2SRT";
    description = "Converts VobSub subtitles into SRT subtitles";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
