{
  lib,
  stdenv,
  fetchurl,
  cmake,
  wxGTK32,
  openal,
  pkg-config,
  curl,
  libtorrent-rasterbar,
  libpng,
  libX11,
  gettext,
  boost,
  libnotify,
  gtk3,
  doxygen,
  spring,
  makeWrapper,
  glib,
  minizip,
  alure,
  pcre,
  jsoncpp,
}:

stdenv.mkDerivation rec {
  pname = "springlobby";
  version = "0.273";

  src = fetchurl {
    url = "https://springlobby.springrts.com/dl/stable/springlobby-${version}.tar.bz2";
    sha256 = "sha256-XkU6i6ABCgw3H9vJu0xjHRO1BglueYM1LyJxcZdOrDk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
    doxygen
    makeWrapper
  ];
  buildInputs = [
    wxGTK32
    openal
    curl
    libtorrent-rasterbar
    pcre
    jsoncpp
    boost
    libpng
    libX11
    libnotify
    gtk3
    glib
    minizip
    alure
  ];

  patches = [
    ./revert_58b423e.patch # Allows springLobby to continue using system installed spring until #707 is fixed
    ./fix-certs.patch
  ];

  postInstall = ''
    wrapProgram $out/bin/springlobby \
      --prefix PATH : "${spring}/bin" \
      --set SPRING_BUNDLE_DIR "${spring}/lib"
  '';

  meta = with lib; {
    homepage = "https://springlobby.springrts.com";
    description = "Cross-platform lobby client for the Spring RTS project";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      qknight
      domenkozar
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
