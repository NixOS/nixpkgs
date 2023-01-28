{ lib, stdenv, fetchurl, unzip, jre8
, copyDesktopItems
, makeDesktopItem
, iconConvTools
}:

stdenv.mkDerivation rec {
  pname = "protege-distribution";
  version = "5.5.0";

  src = fetchurl {
    url = "https://github.com/protegeproject/protege-distribution/releases/download/v${version}/Protege-${version}-platform-independent.zip";
    sha256 = "092x22wyisdnhccx817mqq15sxqdfc7iz4whr4mbvzrd9di6ipjq";
  };

  nativeBuildInputs = [ unzip copyDesktopItems iconConvTools ];

  patches = [
    # Replace logic for searching the install directory with a static cd into $out
    ./static-path.patch
    # Disable console logging, maintaining only file-based logging
    ./disable-console-log.patch
  ];

  postPatch = ''
    # Resolve @out@ (introduced by "static-path.patch") to $out, and set the
    # correct Java executable (Protege is a JRE 8 application)
    substituteInPlace run.sh \
      --subst-var-by out $out \
      --replace "java -X" "exec ${jre8.outPath}/bin/java -X"
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

    # Generate and copy icons to where they can be found
    icoFileToHiColorTheme app/Protege.ico protege $out

    # Move everything else under protege/
    mkdir $out/protege
    mv {bin,bundles,conf,plugins} $out/protege

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Protege";
      desktopName = "Protege Desktop";
      icon = "protege";
      comment = "OWL2 ontology editor";
      categories = [ "Development" ];
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
