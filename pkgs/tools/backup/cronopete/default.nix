{ lib
, stdenv
, fetchFromGitLab
, cmake
, meson
, ninja
, pkg-config

, cairo
, gdk-pixbuf
, gobject-introspection
, gtk3
, libXdmcp
, libXtst
, libayatana-appindicator
, libdatrie
, libepoxy
, libgee
, libnotify
, libselinux
, libsepol
, libthai
, libxkbcommon
, pango
, pcre
, pcre2
, udisks2
, util-linuxMinimal
, rsync
, vala
, wrapGAppsHook
, makeWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cronopete";
  version = "4.15.1";

  src = fetchFromGitLab {
    owner = "rastersoft";
    repo = "cronopete";
    rev = finalAttrs.version;
    hash = "sha256-vXvAkQPxwy9Dnt+IC7mdLJCFenCFIvhjbirY7WPSFKs=";
  };

  patches = [
    ./fix-hardcoded-paths.patch
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    gtk3
    udisks2
    gobject-introspection
    libnotify
    pango
    libayatana-appindicator
    libgee
    pcre2
    util-linuxMinimal # provides libmount
    libselinux
    libsepol
    pcre
    libthai
    libdatrie
    libXdmcp
    libxkbcommon
    libepoxy
    libXtst
  ];

  nativeBuildInputs = [
    cmake
    meson
    ninja
    pkg-config
    vala
    makeWrapper
    wrapGAppsHook
  ];

  postInstall = ''
    wrapProgram $out/bin/cronopete --prefix PATH : ${lib.makeBinPath [rsync]}
  '';

  meta = with lib; {
    description = "An Apple's TimeMachine clone for Linux";
    homepage = "https://gitlab.com/rastersoft/cronopete";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "cronopete";
  };
})
