{ stdenv, fetchFromGitHub, imagemagickBig, pkgconfig, python2Packages, perl
, libX11, libv4l, qt5, lzma, gtk2, xmlto, docbook_xsl, autoreconfHook
, enableVideo ? stdenv.isLinux
}:

let
  inherit (python2Packages) pygtk python;
in stdenv.mkDerivation rec {
  pname = "zbar";
  version = "0.22";

  src = fetchFromGitHub {
    owner = "mchehab";
    repo = "zbar";
    rev = version;
    sha256 = "0pz0vq6a97vnc3lcjw9k12dk2awgmws46cjfh16zin0jiz18d1xq";
  };

  nativeBuildInputs = [ pkgconfig xmlto autoreconfHook docbook_xsl ];

  buildInputs = [
    imagemagickBig python pygtk perl libX11
  ] ++ stdenv.lib.optionals enableVideo [
    libv4l gtk2 qt5.qtbase qt5.qtx11extras
  ];

  configureFlags = [
    "--with-dbusconfdir=$out/etc/dbus-1/system.d"
  ] ++ stdenv.lib.optionals (!enableVideo) [
    "--disable-video" "--without-gtk" "--without-qt"
  ];

  meta = with stdenv.lib; {
    description = "Bar code reader";
    longDescription = ''
      ZBar is an open source software suite for reading bar codes from various
      sources, such as video streams, image files and raw intensity sensors. It
      supports many popular symbologies (types of bar codes) including
      EAN-13/UPC-A, UPC-E, EAN-8, Code 128, Code 39, Interleaved 2 of 5 and QR
      Code.
    '';
    maintainers = with maintainers; [ delroth raskin ];
    platforms = platforms.unix;
    license = licenses.lgpl21;
    homepage = https://github.com/mchehab/zbar;
  };
}
