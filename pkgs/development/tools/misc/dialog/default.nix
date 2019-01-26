{ stdenv, fetchurl, ncurses
, withLibrary ? false, libtool
, unicodeSupport ? true
, enableShared ? !stdenv.isDarwin
}:

assert withLibrary -> libtool != null;
assert unicodeSupport -> ncurses.unicode && ncurses != null;

stdenv.mkDerivation rec {
  name = "dialog-${version}";
  version = "1.3-20181107";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/dialog/${name}.tgz"
      "https://invisible-mirror.net/archives/dialog/${name}.tgz"
    ];
    sha256 = "0mv4a31sz5kc1hyc51cvg9dq54vhlz0vbizn7jgkm9fx4y0cmspg";
  };

  buildInputs = [ ncurses ];

  configureFlags = [
    "--disable-rpath-hacks"
    (stdenv.lib.withFeature withLibrary "libtool")
    "--with-ncurses${stdenv.lib.optionalString unicodeSupport "w"}"
    "--with-libtool-opts=${stdenv.lib.optionalString enableShared "-shared"}"
  ];

  installTargets = "install${stdenv.lib.optionalString withLibrary "-full"}";

  meta = {
    homepage = http://invisible-island.net/dialog/dialog.html;
    description = "Display dialog boxes from shell";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.spacefrogg ];
    platforms = stdenv.lib.platforms.all;
  };
}
