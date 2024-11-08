{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, ffmpeg, libebur128
, libresample, taglib, zlib }:

stdenv.mkDerivation rec {
  pname = "loudgain";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "Moonbase59";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XLj+n0GlY/GAkJlW2JVMd0jxMzgdv/YeSTuF6QUIGwU=";
  };

  patches = [
    # src/scan.c: Only call av_register_all() if using libavformat < 58.9.100
    # https://github.com/Moonbase59/loudgain/pull/50
    ./support-ffmpeg-5.patch

    # src/scan.c: Declare "AVCodec" to be "const AVCodec"
    # https://github.com/Moonbase59/loudgain/pull/65
    ./fix-gcc-14.patch

    # src/scan.c: Update for FFmpeg 7.0
    # https://github.com/Moonbase59/loudgain/pull/66
    ./support-ffmpeg-7.patch
  ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ ffmpeg libebur128 libresample taglib zlib ];

  postInstall = ''
    sed -e "1aPATH=$out/bin:\$PATH" -i "$out/bin/rgbpm"
  '';

  meta = src.meta // {
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
