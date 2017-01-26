{fetchFromGitHub , stdenv, makeWrapper, python3, gtk3, libwnck3 }:

stdenv.mkDerivation  rec {
  name = "clipster-unstable-${version}";
  version = "2017-01-12";

  src = fetchFromGitHub {
    owner = "mrichar1";
    repo = "clipster";
    rev = "d66fbb098149bef687f062bfa111a21c9121851f";
    sha256 = "0yncjfl0822v2b7f9g7a6ihb99g5hd1s8bfpr2r9nqga6m11k90q";
  };

  pythonEnv = python3.withPackages(ps: with ps; [ pygobject3 ]);

  buildInputs =  [ pythonEnv gtk3 libwnck3 makeWrapper ];

  installPhase = ''
    sed -i 's/python/python3/g' clipster
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
