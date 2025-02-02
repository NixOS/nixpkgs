{ lib, fetchFromGitHub, python3Packages, wrapGAppsHook3, gobject-introspection, keybinder3, xdotool }:

python3Packages.buildPythonApplication rec {
  pname = "emote";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "tom-james-watson";
    repo = "Emote";
    rev = "v${version}";
    sha256 = "sha256-+GpL4Rp0ECsxXGP9dWZbVNkH7H2GF1brDTLsB+TQY5A=";
  };

  postPatch = ''
    sed -i setup.py -e '/==.*/d'
    substituteInPlace emote/config.py --replace 'os.environ.get("SNAP")' "'$out/share/emote'"
    substituteInPlace emote/picker.py --replace 'os.environ.get("SNAP_VERSION", "dev build")' "'$version'"
    substituteInPlace snap/gui/emote.desktop --replace "Icon=\''${SNAP}/usr/share/icons/emote.svg" "Icon=emote.svg"
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    # used by gobject-introspection's setup-hook and only detected at runtime
    keybinder3
  ];

  propagatedBuildInputs = with python3Packages; [
    dbus-python.out # don't propagate dev output
    manimpango
    pygobject3.out # not listed in setup.py, don't propagate dev output
    setproctitle
  ];

  postInstall = ''
    install -D snap/gui/emote.desktop $out/share/applications/emote.desktop
    install -D snap/gui/emote.svg $out/share/pixmaps/emote.svg
    install -D -t $out/share/emote/static static/{emojis.csv,logo.svg,style.css}
  '';

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath [ xdotool ]}
    )
  '';

  doCheck = false;

  meta = with lib; {
    description = "Modern emoji picker for Linux";
    mainProgram = "emote";
    homepage = "https://github.com/tom-james-watson/emote";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ emilytrau SuperSandro2000 ];
    platforms = platforms.linux;
  };
}
