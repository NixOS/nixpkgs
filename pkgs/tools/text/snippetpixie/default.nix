{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  vala,
  pkg-config,
  wrapGAppsHook3,
  appstream,
  desktop-file-utils,
  python3,
  libgee,
  glib,
  gtk3,
  sqlite,
  at-spi2-atk,
  at-spi2-core,
  dbus,
  ibus,
  json-glib,
  pantheon,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "snippetpixie";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "bytepixie";
    repo = pname;
    rev = version;
    sha256 = "0gs3d9hdywg4vcfbp4qfcagfjqalfgw9xpvywg4pw1cm3rzbdqmz";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook3
    appstream
    desktop-file-utils
    python3
  ];

  buildInputs = [
    libgee
    glib
    gtk3
    sqlite
    at-spi2-atk
    at-spi2-core
    dbus
    ibus
    json-glib
    xorg.libXtst
    pantheon.granite
  ];

  doCheck = true;

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Your little expandable text snippet helper";
    longDescription = ''
      Your little expandable text snippet helper.

      Save your often used text snippets and then expand them whenever you type their abbreviation.

      For example:- "spr`" expands to "Snippet Pixie rules!"

      For non-accessible applications such as browsers and Electron apps, there's a shortcut (default is Ctrl+`) for opening a search window that pastes the selected snippet.
    '';
    homepage = "https://www.snippetpixie.com";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ianmjones ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "com.github.bytepixie.snippetpixie";
  };
}
