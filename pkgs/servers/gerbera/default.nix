{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config
# required
, libupnp, libuuid, pugixml, libiconv, sqlite, zlib, spdlog, fmt
# options
, enableDuktape ? true, duktape
, enableCurl ? true, curl
, enableTaglib ? true, taglib
, enableLibmagic ? true, file
, enableLibmatroska ? true, libmatroska, libebml
, enableAvcodec ? false, ffmpeg
, enableLibexif ? true, libexif
, enableExiv2 ? false, exiv2
, enableFFmpegThumbnailer ? false, ffmpegthumbnailer
, enableInotifyTools ? true, inotify-tools
}:

with lib;
let
  optionOnOff = option: if option then "on" else "off";
in stdenv.mkDerivation rec {
  pname = "gerbera";
  version = "1.7.0";

  src = fetchFromGitHub {
    repo = "gerbera";
    owner = "gerbera";
    rev = "v${version}";
    sha256 = "sha256-unBToiLSpTtnung77z65iuUqiQHwfMVgmFZMUtKU7fQ=";
  };

  cmakeFlags = [
    "-DWITH_JS=${optionOnOff enableDuktape}"
    "-DWITH_CURL=${optionOnOff enableCurl}"
    "-DWITH_TAGLIB=${optionOnOff enableTaglib}"
    "-DWITH_MAGIC=${optionOnOff enableLibmagic}"
    "-DWITH_MATROSKA=${optionOnOff enableLibmatroska}"
    "-DWITH_AVCODEC=${optionOnOff enableAvcodec}"
    "-DWITH_EXIF=${optionOnOff enableLibexif}"
    "-DWITH_EXIV2=${optionOnOff enableExiv2}"
    "-DWITH_FFMPEGTHUMBNAILER=${optionOnOff enableFFmpegThumbnailer}"
    "-DWITH_INOTIFY=${optionOnOff enableInotifyTools}"
    # systemd service will be generated alongside the service
    "-DWITH_SYSTEMD=OFF"
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libupnp libuuid pugixml libiconv sqlite zlib fmt.dev
    spdlog
  ]
  ++ optionals enableDuktape [ duktape ]
  ++ optionals enableCurl [ curl ]
  ++ optionals enableTaglib [ taglib ]
  ++ optionals enableLibmagic [ file ]
  ++ optionals enableLibmatroska [ libmatroska libebml ]
  ++ optionals enableAvcodec [ ffmpeg.dev ]
  ++ optionals enableLibexif [ libexif ]
  ++ optionals enableExiv2 [ exiv2 ]
  ++ optionals enableInotifyTools [ inotify-tools ]
  ++ optionals enableFFmpegThumbnailer [ ffmpegthumbnailer ];


  meta = with lib; {
    homepage = "https://docs.gerbera.io/";
    description = "UPnP Media Server for 2020";
    longDescription = ''
      Gerbera is a Mediatomb fork.
      It allows to stream your digital media through your home network and consume it on all kinds
      of UPnP supporting devices.
    '';
    license = licenses.gpl2;
    maintainers = [ maintainers.ardumont ];
    platforms = platforms.linux;
  };
}
