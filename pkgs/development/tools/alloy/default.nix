{ stdenv, fetchurl, jre, makeDesktopItem }:

stdenv.mkDerivation rec {
  name = "alloy-${version}";
  version = "4.2_2015-02-22";

  src = fetchurl {
    sha256 = "0p93v8jwx9prijpikkgmfdzb9qn8ljmvga5d9wvrkxddccjx9k28";
    url = "http://alloy.mit.edu/alloy/downloads/alloy${version}.jar";
  };

  desktopItem = makeDesktopItem rec {
    name = "alloy";
    exec = name;
    icon = name;
    desktopName = "Alloy";
    genericName = "Relational modelling tool";
    comment = meta.description;
    categories = "Development;IDE;Education;";
  };

  buildInputs = [ jre ];

  phases = [ "installPhase" ];

  installPhase = ''
    jar=$out/share/alloy/alloy${version}.jar

    install -Dm644 ${src} $jar

    cat << EOF > alloy
    #!${stdenv.shell}
    exec ${jre}/bin/java -jar $jar "\''${@}"
    EOF

    install -Dm755 alloy $out/bin/alloy

    install -Dm644 ${./icon.png} $out/share/pixmaps/alloy.png
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
    homepage = http://alloy.mit.edu/;
    downloadPage = http://alloy.mit.edu/alloy/download.html;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
