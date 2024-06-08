{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, wayland
, wayland-protocols
, libwpe
, libwpe-fdo
, glib-networking
, webkitgtk
, makeWrapper
, wrapGAppsHook3
, gnome
, gdk-pixbuf
}:

stdenv.mkDerivation rec {
  pname = "cog";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "igalia";
    repo = "cog";
    rev = "v${version}";
    sha256 = "sha256-eF7rvOjZntcMmn622342yqfp4ksZ6R/FFBT36bYCViE=";
  };

  buildInputs = [
    wayland-protocols
    wayland
    libwpe
    libwpe-fdo
    webkitgtk
    glib-networking
    gdk-pixbuf
    gnome.adwaita-icon-theme
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland
    makeWrapper
    wrapGAppsHook3
  ];

  depsBuildsBuild = [
    pkg-config
  ];

  cmakeFlags = [
    "-DCOG_USE_WEBKITGTK=ON"
  ];

  # https://github.com/Igalia/cog/issues/438
  postPatch = ''
    substituteInPlace core/cogcore.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  # not ideal, see https://github.com/WebPlatformForEmbedded/libwpe/issues/59
  preFixup = ''
    wrapProgram $out/bin/cog \
      --prefix LD_LIBRARY_PATH : ${libwpe-fdo}/lib
  '';

  meta = with lib; {
    description = "A small single “window” launcher for the WebKit WPE port";
    license = licenses.mit;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.linux;
  };
}
