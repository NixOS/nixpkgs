{ lib
, stdenv
, fetchzip
, jre
, makeWrapper
, nixosTests
, writeTextFile
, extraSpelling ? { } # Custom spelling { en = ["multithreading" "quadtree"]; global=["Nixos"];}
}:
let
  mkSpellFile = lang: data: writeTextFile {
    name = "spelling_custom_" + lang + ".txt";
    text = builtins.concatStringsSep "\n" data;
  };
  mkCustomSpellPath = lang: "$out/share/org/languagetool/resource/" +
    (if lang == "global" then "spelling_global.txt"
    else "${lang}/hunspell/spelling_custom.txt");
  attrValuesAsLines = set: builtins.concatStringsSep "\n" (builtins.attrValues set);
in
stdenv.mkDerivation rec {
  pname = "LanguageTool";
  version = "6.5";

  src = fetchzip {
    url = "https://www.languagetool.org/download/${pname}-${version}.zip";
    sha256 = "sha256-+ZZF/k3eTKT2KbWsk5jJtsdcbkOH90ytlSEEdJ2EMbU=";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    mv -- * $out/share/

    for lt in languagetool{,-commandline,-server};do
      makeWrapper ${jre}/bin/java $out/bin/$lt \
        --add-flags "-cp $out/share/ -jar $out/share/$lt.jar"
    done

    makeWrapper ${jre}/bin/java $out/bin/languagetool-http-server \
      --add-flags "-cp $out/share/languagetool-server.jar org.languagetool.server.HTTPServer"


    ${ attrValuesAsLines (builtins.mapAttrs (lang: data: ''
      mkdir -p $(dirname ${mkCustomSpellPath lang}) # Ensure dir for custom spell exist
      ln -f -s ${mkSpellFile lang data} ${mkCustomSpellPath lang} # symlink to spellfile
    '') extraSpelling) }

    runHook postInstall
  '';

  passthru.tests.languagetool = nixosTests.languagetool;

  meta = with lib; {
    homepage = "https://languagetool.org";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ edwtjo ];
    platforms = jre.meta.platforms;
    description = "Proofreading program for English, French German, Polish, and more";
  };
}
