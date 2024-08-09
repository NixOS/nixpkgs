{ lib, stdenvNoCC, fetchurl, jre, makeWrapper, makeDesktopItem, copyDesktopItems }:

let generic = { version, hash }:
  stdenvNoCC.mkDerivation rec {
    pname = "alloy${lib.versions.major version}";
    inherit version;

    src = fetchurl {
      inherit hash;
      url = "https://github.com/AlloyTools/org.alloytools.alloy/releases/download/v${version}/org.alloytools.alloy.dist.jar";
    };

    desktopItems = [
      (makeDesktopItem {
        name = pname;
        exec = pname;
        icon = pname;
        desktopName = "Alloy ${lib.versions.major version}";
        genericName = "Relational modelling tool";
        comment = meta.description;
        categories = [ "Development" "IDE" "Education" ];
      })
    ];

    nativeBuildInputs = [ copyDesktopItems makeWrapper ];

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      jar=$out/share/alloy/${pname}.jar
      install -Dm644 ${src} $jar

      makeWrapper ${jre}/bin/java $out/bin/${pname} --add-flags \
        "-jar $jar"

      install -Dm644 ${./icon.png} $out/share/pixmaps/${pname}.png

      runHook postInstall
    '';

    meta = {
      description = "Language & tool for relational models";
      longDescription = ''
        Alloy is a language for describing structures and a tool for exploring
        them. An Alloy model is a collection of constraints that describes a set
        of structures, e.g. all the possible security configurations of a web
        application, or all the possible topologies of a switching network. The
        Alloy Analyzer is a solver that takes the constraints of a model and
        finds structures that satisfy them. Structures are displayed graphically,
        and their appearance can be customized for the domain at hand.
      '';
      homepage = "https://alloytools.org/";
      downloadPage = "https://alloytools.org/download.html";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ notbandali ];
      mainProgram = pname;
    };
  };

in rec {
  alloy5 = generic {
    version = "5.1.0";
    hash = "sha256-o7Q+jsmWeUeuotUQG9lrPE6w2B6z3Ju6QcyWSTScaQo=";
  };

  alloy6 = generic {
    version = "6.0.0";
    hash = "sha256-rA7mNxcu0DWkykMyfV4JwFmQqg0HOIcwjjD4jCRxNww=";
  };

  alloy = alloy5;
}
