{ stdenv, lib, fetchFromGitHub
, sqlite, expat
, libuuid, libupnp, pugixml
, cmake, pkgconfig
, avcodecSupport ? false, libav ? null
, curlSupport ? true, curl ? null
, exifSupport ? true, libexif ? null
, exiv2Support ? false, exiv2 ? null
, ffmpegthumbnailerSupport ? true, ffmpegthumbnailer ? null
, inotifySupport ? true, inotify-tools ? null
, jsSupport ? true, duktape ? null
, lastfmSupport ? false, liblastfm ? null
, magicSupport ? true, file ? null
, matroskaSupport ? true, libmatroska ? null, libebml ? null
, mysqlSupport ? false, mysql ? null
, systemdSupport ? false, systemd ? null
, taglibSupport ? true, taglib ? null
, testSupport ? false, gmock ? null
}:

assert avcodecSupport -> libav != null;
assert curlSupport -> curl != null;
assert exifSupport -> libexif != null;
assert exiv2Support -> exiv2 != null;
assert ffmpegthumbnailerSupport -> ffmpegthumbnailer != null;
assert inotifySupport -> inotify-tools != null;
assert jsSupport -> duktape != null;
assert lastfmSupport -> liblastfm != null;
assert magicSupport -> file != null;
assert matroskaSupport -> libmatroska != null && libebml != null;
assert mysqlSupport -> mysql != null;
assert taglibSupport -> taglib != null;

stdenv.mkDerivation rec {
  pname = "gerbera";
  version = "1.4.0";

  doCheck = testSupport;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v" + version;
    sha256 = "Ad9K3ZDLI7I1B0Ht7HJpw9/8wVvLXYEhmi60zK5cufQ=";
  };

  buildInputs =
  let
    libupnpReuse = libupnp.overrideAttrs (attrs: {
      configureFlags = "--enable-reuseaddr";
    });
  in
  with lib; [
    cmake pkgconfig
    libuuid libupnpReuse
    sqlite expat
  ]
  ++ optional avcodecSupport libav
  ++ optional curlSupport curl
  ++ optional exifSupport libexif
  ++ optional exiv2Support exiv2
  ++ optional ffmpegthumbnailerSupport ffmpegthumbnailer
  ++ optional inotifySupport inotify-tools
  ++ optional jsSupport duktape
  ++ optional lastfmSupport liblastfm
  ++ optional magicSupport file
  ++ optionals matroskaSupport [ libmatroska libebml ]
  ++ optional mysqlSupport mysql
  ++ optional systemdSupport systemd
  ++ optional taglibSupport taglib
  ++ optional testSupport gmock
  ;

  cmakeFlags =
    let
      onOff = b: if b then "ON" else "OFF";
      flag = n: b: "-D"+n+"="+onOff b;
    in
    with lib; [
      (flag "WITH_AVCODEC" avcodecSupport)
      (flag "WITH_CURL" curlSupport)
      (flag "WITH_EXIF" exifSupport)
      (flag "WITH_EXIV2" exiv2Support)
      (flag "WITH_FFMPEGTHUMBNAILER" ffmpegthumbnailerSupport)
      (flag "WITH_JS" jsSupport)
      (flag "WITH_LASTFM" lastfmSupport)
      (flag "WITH_MAGIC" magicSupport)
      (flag "WITH_MATROSKA" matroskaSupport)
      (flag "WITH_MYSQL" mysqlSupport)
      (flag "WITH_SYSTEMD" systemdSupport)
      (flag "WITH_TESTS" testSupport)
    ];

  meta = with stdenv.lib; {
    homepage = "http://gerbera.io";
    description = "UPnP Media Server for 2020";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}
