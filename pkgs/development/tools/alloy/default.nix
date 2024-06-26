{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
  makeDesktopItem,
}:

let
  generic =
    { version, sha256 }:
    stdenv.mkDerivation rec {
      pname = "alloy${lib.versions.major version}";
      inherit version;

      src = fetchurl {
        inherit sha256;
        url = "https://github.com/AlloyTools/org.alloytools.alloy/releases/download/v${version}/org.alloytools.alloy.dist.jar";
      };

      desktopItem = makeDesktopItem rec {
        name = pname;
        exec = name;
        icon = name;
        desktopName = "Alloy ${lib.versions.major version}";
        genericName = "Relational modelling tool";
        comment = meta.description;
        categories = [
          "Development"
          "IDE"
          "Education"
        ];
      };

      nativeBuildInputs = [ makeWrapper ];

      buildCommand = ''
        jar=$out/share/alloy/${pname}.jar
        install -Dm644 ${src} $jar

        mkdir -p $out/bin
        makeWrapper ${jre}/bin/java $out/bin/${pname} --add-flags \
          "-jar $jar"

        install -Dm644 ${./icon.png} $out/share/pixmaps/${pname}.png
        cp -r ${desktopItem}/share/applications $out/share
      '';

      meta = with lib; {
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
        homepage = "http://alloytools.org/";
        downloadPage = "http://alloytools.org/download.html";
        sourceProvenance = with sourceTypes; [ binaryBytecode ];
        license = licenses.mit;
        platforms = platforms.unix;
        maintainers = with maintainers; [ notbandali ];
      };
    };

in
rec {
  alloy5 = generic rec {
    version = "5.1.0";
    sha256 = "02k9khs4k5nc86x9pp5k3vcb0kiwdgcin46mlap4fycnr673xd53";
  };

  alloy6 = generic rec {
    version = "6.0.0";
    sha256 = "sha256-rA7mNxcu0DWkykMyfV4JwFmQqg0HOIcwjjD4jCRxNww=";
  };

  alloy = alloy5;
}
