{fetchFromGitHub , stdenv, makeWrapper, python, gtk3,  libwnck3 }:

stdenv.mkDerivation  rec {
  name = "clipster-unstable-${version}";
  version = "2016-09-12";

  src = fetchFromGitHub {
    owner = "mrichar1";
    repo = "clipster";
    rev = "6526a849a0af4c392f4e8e5b18aacdda9c1a8e80";
    sha256 = "0illdajp5z50h7lvglv0p72cpv4c592xmpamrg8kkjpg693bp873";
  };

  pythonEnv = python.withPackages(ps: with ps; [ dbus-python pygtk pygobject3 ]);

  buildInputs =  [ pythonEnv gtk3 libwnck3 makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin/
    cp clipster $out/bin/
    wrapProgram "$out/bin/clipster" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"
  '';

  meta = with stdenv.lib; {
    description = "lightweight python clipboard manager";
    longDescription = ''
      Clipster was designed to try to add a good selection of useful features, while avoiding bad design decisions or becoming excessively large.
      Its feature list includes:
      - Event driven, rather than polling. More efficient, helps with power management.
      - Control over when it write to disk, for similar reasons.
      - Command-line options/config for everything.
      - No global keybindings - that's the job of a Window Manager
      - Sensible handling of unusual clipboard events. Some apps (Chrome, Emacs) trigger a clipboard 'update event' for every character you select, rather than just one event when you stop selecting.
      - Preserves the last item in clipboard after an application closes. (Many apps clear the clipboard on exit).
      - Minimal dependencies, no complicated build/install requirements.
      - utf-8 support
      - Proper handling of embedded newlines and control codes.
      - Smart matching of urls, emails, regexes. (extract_*)
      - Option to synchronise the SELECTION and CLIPBOARD clipboards. (sync_selections)
      - Option to track one or both clipboards. (active_selections)
      - Option to ignore clipboard updates form certain applications. (filter_classes)
      - Ability to delete items in clipboard history.
    '';
    license = licenses.agpl3;
    homepage = https://github.com/mrichar1/clipster;
    platforms = platforms.linux;
    maintainers = [maintainers.magnetophon];
  };
}
