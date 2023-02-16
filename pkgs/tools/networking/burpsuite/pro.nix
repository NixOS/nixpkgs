{ lib, stdenv, fetchurl, jdk11, runtimeShell, unzip, chromium }:

stdenv.mkDerivation rec {
  pname = "burpsuite-pro";
  version = "2022.3.4";

  src = fetchurl {
    name = "burpsuite.jar";
    urls = [
      "https://portswigger-cdn.net/burp/releases/download?product=pro&version=${version}&type=Jar"
    ];
    sha256 = "sha256:0p9cmaqfaqycvpvl7jbdgshlc4wg6b6wvpja4wnw8349bbcbx4np";
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

      Note that you need to get a trial key or a subscription on burpsuite to use this package.
      Eg: https://portswigger.net/burp/pro/trial
      It gives the active scan option.
    '';
    homepage = "https://portswigger.net/burp/pro";
    downloadPage = "https://portswigger.net/burp/releases";
    license = licenses.unfree;
    platforms = jdk11.meta.platforms;
    hydraPlatforms = [];
    maintainers = with maintainers; [ jappie ];
  };
}
