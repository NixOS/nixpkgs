{ lib, stdenv, fetchurl, unzip, jre8, copyDesktopItems, makeDesktopItem }:

stdenv.mkDerivation rec {
  pname = "protege-distribution";
  version = "5.5.0";

  src = fetchurl {
    url = "https://github.com/protegeproject/protege-distribution/releases/download/v${version}/Protege-${version}-platform-independent.zip";
    sha256 = "092x22wyisdnhccx817mqq15sxqdfc7iz4whr4mbvzrd9di6ipjq";
  };

  nativeBuildInputs = [ unzip copyDesktopItems ];

  postPatch = ''
    # Delete all those commands meant to change directory to the source directory
    sed -i -e '3,9d' run.sh

    # Change directory to where the application is stored to avoid heavy patching
    # of searchpaths
    sed -i -e "2a\
    cd $out/protege" run.sh

    # Set the correct Java executable (Protege is a JRE 8 application)
    substituteInPlace run.sh \
      --replace "java -X" "exec ${jre8.outPath}/bin/java -X" \

    # Silence console logs, since these are not shown in graphical environments
    sed -i -e '4,8d;21d' conf/logback.xml
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out

    # Delete non-Linux launch scripts
    rm run.{bat,command}

    # Move launch script into /bin, giving it a recognizable name
    install -D run.sh $out/bin/run-protege

    # Copy icon to where it can be found
    install -D app/Protege.ico $out/share/icons/hicolor/128x128/apps/protege.ico

    # Move everything else under protege/
    mkdir $out/protege
    mv {bin,bundles,conf,plugins} $out/protege

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Protege";
      desktopName = "Protege Desktop";
      icon = "protege.ico";
      comment = "OWL2 ontology editor";
      exec = "run-protege";
    })
  ];

  meta = with lib; {
    description = "The OWL2 ontology editor from Stanford, with third-party plugins included";
    homepage = "https://protege.stanford.edu/";
    downloadPage = "https://protege.stanford.edu/products.php#desktop-protege";
    maintainers = with maintainers; [ nessdoor ];
    license = with licenses; [ asl20 bsd2 epl10 lgpl3 ];
    platforms = platforms.linux;
  };
}
