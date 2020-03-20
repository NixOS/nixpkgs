{ stdenv
, fetchFromGitHub
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
, libwnck3
, xorg
}:

stdenv.mkDerivation rec {
  pname = "snippetpixie";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "bytepixie";
    repo = pname;
    rev = version;
    sha256 = "0cnx7snw3h7p77fhihvqxb6bgg4s2ffvjr8nbymb4bnqlg2a7v97";
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
    libwnck3
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
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Your little expandable text snippet helper";
    longDescription = ''
      Your little expandable text snippet helper.

      Save your often used text snippets and then expand them whenever you type their abbreviation.

      For example:- "spr`" expands to "Snippet Pixie rules!"
    '';
    homepage = https://www.snippetpixie.com;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      ianmjones
    ] ++ pantheon.maintainers;
    platforms = platforms.linux;
  };
}
