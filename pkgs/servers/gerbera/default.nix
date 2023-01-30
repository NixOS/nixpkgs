{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, nixosTests
  # required
, libiconv
, libupnp
, libuuid
, pugixml
, spdlog
, sqlite
, zlib
  # options
, enableMysql ? false
, libmysqlclient
, enableDuktape ? true
, duktape
, enableCurl ? true
, curl
, enableTaglib ? true
, taglib
, enableLibmagic ? true
, file
, enableLibmatroska ? true
, libmatroska
, libebml
, enableAvcodec ? false
, ffmpeg
, enableLibexif ? true
, libexif
, enableExiv2 ? false
, exiv2
, enableFFmpegThumbnailer ? false
, ffmpegthumbnailer
, enableInotifyTools ? true
, inotify-tools
}:

let
  libupnp' = libupnp.overrideAttrs (super: rec {
    cmakeFlags = super.cmakeFlags or [ ] ++ [
      "-Dblocking_tcp_connections=OFF"
      "-Dreuseaddr=ON"
    ];
  });

  options = [
    { name = "AVCODEC"; enable = enableAvcodec; packages = [ ffmpeg ]; }
    { name = "CURL"; enable = enableCurl; packages = [ curl ]; }
    { name = "EXIF"; enable = enableLibexif; packages = [ libexif ]; }
    { name = "EXIV2"; enable = enableExiv2; packages = [ exiv2 ]; }
    { name = "FFMPEGTHUMBNAILER"; enable = enableFFmpegThumbnailer; packages = [ ffmpegthumbnailer ]; }
    { name = "INOTIFY"; enable = enableInotifyTools; packages = [ inotify-tools ]; }
    { name = "JS"; enable = enableDuktape; packages = [ duktape ]; }
    { name = "MAGIC"; enable = enableLibmagic; packages = [ file ]; }
    { name = "MATROSKA"; enable = enableLibmatroska; packages = [ libmatroska libebml ]; }
    { name = "MYSQL"; enable = enableMysql; packages = [ libmysqlclient ]; }
    { name = "TAGLIB"; enable = enableTaglib; packages = [ taglib ]; }
  ];

  inherit (lib) flatten optionals;

in
stdenv.mkDerivation rec {
  pname = "gerbera";
  version = "1.12.1";

  src = fetchFromGitHub {
    repo = "gerbera";
    owner = "gerbera";
    rev = "v${version}";
    sha256 = "sha256-j5J0u0zIjHY2kP5P8IzN2h+QQSCwsel/iTspad6V48s=";
  };

  postPatch = lib.optionalString enableMysql ''
    substituteInPlace cmake/FindMySQL.cmake \
      --replace /usr/include/mysql ${lib.getDev libmysqlclient}/include/mariadb \
      --replace /usr/lib/mysql     ${lib.getLib libmysqlclient}/lib/mariadb
  '';

  cmakeFlags = [
    # systemd service will be generated alongside the service
    "-DWITH_SYSTEMD=OFF"
  ] ++ map (e: "-DWITH_${e.name}=${if e.enable then "ON" else "OFF"}") options;

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libiconv
    libupnp'
    libuuid
    pugixml
    spdlog
    sqlite
    zlib
  ] ++ flatten (builtins.catAttrs "packages" (builtins.filter (e: e.enable) options));

  passthru.tests = { inherit (nixosTests) mediatomb; };

  meta = with lib; {
    homepage = "https://docs.gerbera.io/";
    description = "UPnP Media Server for 2020";
    longDescription = ''
      Gerbera is a Mediatomb fork.
      It allows to stream your digital media through your home network and consume it on all kinds
      of UPnP supporting devices.
    '';
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ardumont ];
    platforms = platforms.linux;
  };
}
