{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, graphicsmagick, libjpeg
, ffmpeg, zlib, libexif }:

stdenv.mkDerivation rec {
  pname = "timg";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "timg";
    rev = "v${version}";
    sha256 = "1zjcaxnik8imkn22g5kz6zly3yxpknrzd093sfxpgqnfw4sq8149";
  };

  buildInputs = [ graphicsmagick ffmpeg libexif libjpeg zlib ];

  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DTIMG_VERSION_FROM_GIT=Off"
    "-DWITH_VIDEO_DECODING=On"
    "-DWITH_VIDEO_DEVICE=On"
    "-DWITH_OPENSLIDE_SUPPORT=Off" # https://openslide.org/ lib not yet in nix
  ];

  meta = with lib; {
    homepage = "https://timg.sh/";
    description = "A terminal image and video viewer";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ hzeller ];
  };
}
