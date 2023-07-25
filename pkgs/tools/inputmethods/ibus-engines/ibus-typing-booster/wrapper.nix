{ typing-booster, symlinkJoin, hunspellDicts, lib, makeWrapper
, langs ? [ "de-de" "en-gb-ise" "en-us" "es-es" "fr-moderne" "it-it" "sv-se" "sv-fi" ]
}:

let

  hunspellDirs = lib.makeSearchPath "share/hunspell" (lib.attrVals langs hunspellDicts);

in

symlinkJoin {
  name = "${typing-booster.name}-with-hunspell";
  paths = [ typing-booster ];
  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    for i in bin/emoji-picker libexec/ibus-{setup,engine}-typing-booster; do
      wrapProgram "$out/$i" \
        --prefix DICPATH : ${lib.escapeShellArg hunspellDirs}
    done

    sed -i -e "s,${typing-booster},$out," $out/share/ibus/component/typing-booster.xml
  '';

  inherit (typing-booster) meta;
}
