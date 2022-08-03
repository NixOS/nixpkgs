{ lib, stdenvNoCC, fetchzip, makeWrapper, jre, bash, gawk, icoutils, copyDesktopItems, makeDesktopItem }:

stdenvNoCC.mkDerivation rec {
  pname = "maltego";
  version = "4.3.0";

  src = fetchzip {
    url = "https://maltego-downloads.s3.us-east-2.amazonaws.com/linux/Maltego.v${version}.linux.zip";
    sha256 = "1xflh5vyl6dqbzsam3m0larsrgnwgzikqsfmg77y5qy3nyfa15gf";
  };

  postPatch = ''
    substituteInPlace bin/maltego \
      --replace "/bin/bash" "${bash}/bin/bash" \
      --replace "/usr/bin/awk" "${gawk}/bin/awk"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Maltego";
      exec = pname;
      icon = pname;
      comment = "An open source intelligence and forensics application";
      categories = [ "Network" "Security" ];
      startupNotify = false;
    })
  ];

  nativeBuildInputs = [
    icoutils
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share share/icons/hicolor/48x48/apps
    cp -r . $out/share/maltego

    icotool -x bin/maltego.ico
    for size in 16 24 32 48 64 128 256
    do
      mkdir -p $out/share/icons/hicolor/$size\x$size/apps
      cp maltego_*_$size\x$size\x32.png $out/share/icons/hicolor/$size\x$size/apps/maltego.png
    done

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/share/maltego/bin/maltego $out/bin/maltego \
      --chdir $out/share/maltego/bin \
      --prefix PATH : "${lib.makeBinPath [ jre ]}"
  '';

  meta = with lib; {
    description = "An open source intelligence and forensics application, enabling to easily gather information about DNS, domains, IP addresses, websites, persons, etc.";
    homepage = "https://www.maltego.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
