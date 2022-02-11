{ lib, fetchFromGitHub, python3Packages, wrapGAppsHook, gobject-introspection, gtk3, keybinder3, xdotool, pango, gdk-pixbuf, atk, librsvg }:

python3Packages.buildPythonApplication rec {
  pname = "emote";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "tom-james-watson";
    repo = "Emote";
    rev = "v${version}";
    sha256 = "mqCSl+EGbnL9AfzZT3aa/Y5Rsx433ZmI31BmK3wkaJk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pygobject==3.36.0" "pygobject" \
      --replace "manimpango==0.3.0" "manimpango"
    substituteInPlace emote/config.py --replace 'os.environ.get("SNAP")' "'$out/share/emote'"
    substituteInPlace emote/picker.py --replace 'os.environ.get("SNAP_VERSION", "dev build")' "'$version'"
    substituteInPlace snap/gui/emote.desktop --replace "Icon=\''${SNAP}/usr/share/icons/emote.svg" "Icon=emote.svg"
  '';

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
    keybinder3
    pango
    gdk-pixbuf
    atk
  ];

  propagatedBuildInputs = [
    python3Packages.manimpango
    python3Packages.pygobject3
    gtk3
    xdotool
    librsvg
  ];

  postInstall = ''
    install -D snap/gui/emote.desktop $out/share/applications/emote.desktop
    install -D snap/gui/emote.svg $out/share/pixmaps/emote.svg
    install -D -t $out/share/emote/static static/{NotoColorEmoji.ttf,emojis.csv,logo.svg,style.css}
  '';

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  doCheck = false;

  meta = with lib; {
    description = "A modern emoji picker for Linux";
    homepage = "https://github.com/tom-james-watson/emote";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.linux;
  };
}
