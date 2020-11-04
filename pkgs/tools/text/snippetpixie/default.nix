{ stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, vala
, pkgconfig
, wrapGAppsHook
, appstream
, desktop-file-utils
, python3
, libgee
, glib
, gtk3
, sqlite
, at-spi2-atk
, at-spi2-core
, dbus
, ibus
, json-glib
, pantheon
, xorg
}:

stdenv.mkDerivation rec {
  pname = "snippetpixie";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "bytepixie";
    repo = pname;
    rev = version;
    sha256 = "1db3fbawh4qwdqby5ji4g26pksi4q253r5zvd3kv1m2ljmwrrwj0";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkgconfig
    wrapGAppsHook
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
    pantheon.elementary-gtk-theme
    pantheon.elementary-icon-theme
  ];

  doCheck = true;

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Your little expandable text snippet helper";
    longDescription = ''
      Your little expandable text snippet helper.

      Save your often used text snippets and then expand them whenever you type their abbreviation.

      For example:- "spr`" expands to "Snippet Pixie rules!"

      For non-accessible applications such as browsers and Electron apps, there's a shortcut (default is Ctrl+`) for opening a search window that pastes the selected snippet.
    '';
    homepage = "https://www.snippetpixie.com";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      ianmjones
    ] ++ pantheon.maintainers;
    platforms = platforms.linux;
  };
}
