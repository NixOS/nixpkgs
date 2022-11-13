{ lib, stdenv, fetchurl, makeDesktopItem, jdk11, runtimeShell, unzip, chromium }:

stdenv.mkDerivation rec {
  pname = "burpsuite";
  version = "2021.12";

  src = fetchurl {
    name = "burpsuite.jar";
    urls = [
      "https://portswigger.net/Burp/Releases/Download?productId=100&version=${version}&type=Jar"
      "https://web.archive.org/web/https://portswigger.net/Burp/Releases/Download?productId=100&version=${version}&type=Jar"
    ];
    sha256 = "sha256-BLX/SgHctXciOZoA6Eh4zuDJoxNSZgvoj2Teg1fV80g=";
  };

  desktopItem = makeDesktopItem rec {
    name = pname;
    exec = pname;
    icon = pname;
    desktopName = "Burp Suite Community Edition";
    comment = meta.description;
    categories = [ "Development" "Security" "System" ];
  };

  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    echo '#!${runtimeShell}
    eval "$(${unzip}/bin/unzip -p ${src} chromium.properties)"
    mkdir -p "$HOME/.BurpSuite/burpbrowser/$linux64"
    ln -sf "${chromium}/bin/chromium" "$HOME/.BurpSuite/burpbrowser/$linux64/chrome"
    exec ${jdk11}/bin/java -jar ${src} "$@"' > $out/bin/burpsuite
    chmod +x $out/bin/burpsuite

    install -Dm644 ${./icon.png} $out/share/pixmaps/${pname}.png
    cp -r ${desktopItem}/share/applications $out/share

    runHook postInstall
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "An integrated platform for performing security testing of web applications";
    longDescription = ''
      Burp Suite is an integrated platform for performing security testing of web applications.
      Its various tools work seamlessly together to support the entire testing process, from
      initial mapping and analysis of an application's attack surface, through to finding and
      exploiting security vulnerabilities.
    '';
    homepage = "https://portswigger.net/burp/";
    downloadPage = "https://portswigger.net/burp/freedownload";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    platforms = jdk11.meta.platforms;
    hydraPlatforms = [];
    maintainers = with maintainers; [ bennofs ];
  };
}
