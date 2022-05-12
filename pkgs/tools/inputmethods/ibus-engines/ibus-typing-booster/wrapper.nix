{ typing-booster, symlinkJoin, hunspellDicts, lib, makeWrapper
, langs ? [ "de-de" "en-us" "es-es" "fr-moderne" "it-it" "sv-se" "sv-fi" ]
}:

let

  hunspellDirs = with lib; makeSearchPath ":" (flatten (forEach langs (lang: [
    "${hunspellDicts.${lang}}/share/hunspell"
    "${hunspellDicts.${lang}}/share/myspell"
    "${hunspellDicts.${lang}}/share/myspell/dicts"
  ])));

in

symlinkJoin {
  name = "${typing-booster.name}-with-hunspell";
  paths = [ typing-booster ];
  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    for i in bin/emoji-picker libexec/ibus-{setup,engine}-typing-booster; do
      wrapProgram "$out/$i" \
        --prefix NIX_HUNSPELL_DIRS : ${lib.escapeShellArg hunspellDirs}
    done

    sed -i -e "s,${typing-booster},$out," $out/share/ibus/component/typing-booster.xml
  '';

  inherit (typing-booster) meta;
}
