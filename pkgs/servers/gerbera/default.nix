{ stdenv, fetchFromGitHub
, cmake, pkg-config
# required
, libupnp, libuuid, pugixml, libiconv, sqlite, zlib, spdlog, fmt
, pkgs
# options
, enableDuktape ? true
, enableCurl ? true
, enableTaglib ? true
, enableLibmagic ? true
, enableLibmatroska ? true
, enableAvcodec ? false
, enableLibexif ? true
, enableExiv2 ? false
, enableFFmpegThumbnailer ? false
, enableInotifyTools ? true
}:

with stdenv.lib;
let
  optionOnOff = option: if option then "on" else "off";
in stdenv.mkDerivation rec {
  pname = "gerbera";
  version = "1.6.4";

  src = fetchFromGitHub {
    repo = "gerbera";
    owner = "gerbera";
    rev = "v${version}";
    sha256 = "0vkgbw2ibvfr0zffnmmws7389msyqsiw8anfad6awvkda3z3rxjm";
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
  ++ optionals enableDuktape [ pkgs.duktape ]
  ++ optionals enableCurl [ pkgs.curl ]
  ++ optionals enableTaglib [ pkgs.taglib ]
  ++ optionals enableLibmagic [ pkgs.file ]
  ++ optionals enableLibmatroska [ pkgs.libmatroska pkgs.libebml ]
  ++ optionals enableAvcodec [ pkgs.libav.dev ]
  ++ optionals enableLibexif [ pkgs.libexif ]
  ++ optionals enableExiv2 [ pkgs.exiv2 ]
  ++ optionals enableInotifyTools [ pkgs.inotify-tools ]
  ++ optionals enableFFmpegThumbnailer [ pkgs.ffmpegthumbnailer ];


  meta = with stdenv.lib; {
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
