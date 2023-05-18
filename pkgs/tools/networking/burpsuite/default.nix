{ lib, fetchurl, jdk, buildFHSEnv, unzip, makeDesktopItem }:
let
  version = "2023.4.3";

  src = fetchurl {
    name = "burpsuite.jar";
    urls = [
      "https://portswigger.net/burp/releases/download?productId=100&version=${version}&type=Jar"
      "https://web.archive.org/web/https://portswigger.net/burp/releases/download?productId=100&version=${version}&type=Jar"
    ];
    sha256 = "2e756e48f31b88590445f2b1dc4806c2f3613f9fde4dab357acb3850fd77303e";
  };

  name = "burpsuite-${version}";
  description = "An integrated platform for performing security testing of web applications";
  desktopItem = makeDesktopItem rec {
    name = "burpsuite";
    exec = name;
    icon = name;
    desktopName = "Burp Suite Community Edition";
    comment = description;
    categories = [ "Development" "Security" "System" ];
  };

in
buildFHSEnv {
  inherit name;

  runScript = "${jdk}/bin/java -jar ${src}";

  targetPkgs = pkgs: with pkgs; [
    alsa-lib
    at-spi2-core
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libudev0-shim
    libxkbcommon
    mesa.drivers
    nspr
    nss
    pango
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
  ];

  extraInstallCommands = ''
    mv "$out/bin/${name}" "$out/bin/burpsuite" # name includes the version number
    mkdir -p "$out/share/pixmaps"
    ${lib.getBin unzip}/bin/unzip -p ${src} resources/Media/icon64community.png > "$out/share/pixmaps/burpsuite.png"
    cp -r ${desktopItem}/share/applications $out/share
  '';

  meta = with lib; {
    inherit description;
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
    platforms = jdk.meta.platforms;
    hydraPlatforms = [ ];
    maintainers = with maintainers; [ bennofs stepech ];
  };
}
