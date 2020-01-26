{ stdenv, fetchurl, jre, makeWrapper, makeDesktopItem }:

let generic = { major, version, src }:

  stdenv.mkDerivation rec {
    name = "${nameMajor}-${version}";
    nameMajor = "alloy${major}";

    desktopItem = makeDesktopItem rec {
      name = nameMajor;
      exec = name;
      icon = name;
      desktopName = "Alloy ${major}";
      genericName = "Relational modelling tool";
      comment = meta.description;
      categories = "Development;IDE;Education;";
    };

    nativeBuildInputs = [ makeWrapper ];

    buildCommand = ''
      jar=$out/share/alloy/${nameMajor}.jar
      install -Dm644 ${src} $jar

      mkdir -p $out/bin
      makeWrapper ${jre}/bin/java $out/bin/${nameMajor} --add-flags \
       "-jar $jar"

      install -Dm644 ${./icon.png} $out/share/pixmaps/${nameMajor}.png
      cp -r ${desktopItem}/share/applications $out/share
    '';

    meta = with stdenv.lib; {
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
      homepage = http://alloytools.org/;
      downloadPage = http://alloytools.org/download.html;
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ aminb ];
    };
  };

in rec {
  alloy4 = let version = "4.2_2015-02-22"; in generic {
    major = "4";
    inherit version;
    src = fetchurl {
      sha256 = "0p93v8jwx9prijpikkgmfdzb9qn8ljmvga5d9wvrkxddccjx9k28";
      url = "http://alloytools.org/download/alloy${version}.jar";
    };
  };

  alloy5 = let version = "5.1.0"; in generic {
    major = "5";
    inherit version;
    src = fetchurl {
      sha256 = "02k9khs4k5nc86x9pp5k3vcb0kiwdgcin46mlap4fycnr673xd53";
      url = "https://github.com/AlloyTools/org.alloytools.alloy/releases/download/v${version}/org.alloytools.alloy.dist.jar";
    };
  };

  alloy = alloy5;
}
