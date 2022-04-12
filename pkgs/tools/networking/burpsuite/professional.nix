{ lib, stdenv, fetchurl, openjdk, runtimeShell, unzip, chromium }:
stdenv.mkDerivation rec {
  pname = "burpsuite-pro";
  version = "2022.3.4";

  src = fetchurl {
    name = "burpsuite.jar";
    urls = [
      "https://portswigger.net/Burp/Releases/Download?product=pro&version=${version}&type=Jar"
      "https://web.archive.org/web/https://portswigger.net/Burp/Releases/Download?product=pro&version=${version}&type=Jar"
    ];
    sha256 = "0p9cmaqfaqycvpvl7jbdgshlc4wg6b6wvpja4wnw8349bbcbx4np";
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
    exec ${openjdk}/bin/java --illegal-access=permit -jar ${src} "$@"' > $out/bin/burpsuite-pro
    chmod +x $out/bin/burpsuite-pro

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
    license = licenses.unfree;
    platforms = openjdk.meta.platforms;
    hydraPlatforms = [];
    maintainers = with maintainers; [ madonius ];
  };
}
