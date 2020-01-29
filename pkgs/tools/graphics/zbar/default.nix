{ stdenv
, lib
, fetchFromGitHub
, imagemagickBig
, pkgconfig
, libX11
, libv4l
, qtbase
, qtx11extras
, wrapQtAppsHook
, wrapGAppsHook
, gtk3
, xmlto
, docbook_xsl
, autoreconfHook
, dbus
, enableVideo ? stdenv.isLinux
, enableDbus ? stdenv.isLinux
}:

stdenv.mkDerivation rec {
  pname = "zbar";
  version = "0.23";

  outputs = [ "out" "lib" "dev" "doc" "man" ];

  src = fetchFromGitHub {
    owner = "mchehab";
    repo = "zbar";
    rev = version;
    sha256 = "0hlxakpyjg4q9hp7yp3har1n78341b4knwyll28hn48vykg28pza";
  };

  nativeBuildInputs = [
    pkgconfig
    xmlto
    autoreconfHook
    docbook_xsl
    wrapQtAppsHook
    wrapGAppsHook
  ];

  buildInputs = [
    imagemagickBig
    libX11
  ] ++ lib.optionals enableDbus [
    dbus
  ] ++ lib.optionals enableVideo [
    libv4l
    gtk3
    qtbase
    qtx11extras
  ];

  # Disable assertions which include -dev QtBase file paths.
  NIX_CFLAGS_COMPILE = "-DQT_NO_DEBUG";

  configureFlags = [
    "--without-python"
  ] ++ (if enableDbus then [
    "--with-dbusconfdir=${placeholder "out"}/share"
  ] else [
    "--without-dbus"
  ]) ++ (if enableVideo then [
    "--with-gtk=gtk3"
  ] else [
    "--disable-video"
    "--without-gtk"
    "--without-qt"
  ]);

  dontWrapQtApps = true;
  dontWrapGApps = true;

  postFixup = lib.optionalString enableVideo ''
    wrapGApp "$out/bin/zbarcam-gtk"
    wrapQtApp "$out/bin/zbarcam-qt"
  '';

  meta = with lib; {
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
