{ lib, stdenv, fetchurl, openjdk, runtimeShell, unzip, chromium }:

stdenv.mkDerivation rec {
  pname = "burpsuite";
  version = "2022.3.4";

  src = fetchurl {
    name = "burpsuite.jar";
    urls = [
      "https://portswigger-cdn.net/burp/releases/download?product=community&version=${version}&type=Jar"
      "https://web.archive.org/web/https://portswigger-cdn.net/burp/releases/download?product=community&version=${version}&type=Jar"
    ];
    sha256 = "1mjfsg6dhiac9i7nicz34x8a5181jpyl7c8sdfk3y1291g7h202y";
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
    exec ${openjdk}/bin/java --illegal-access=permit -jar ${src} "$@"' > $out/bin/burpsuite
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
    '';
    homepage = "https://portswigger.net/burp/";
    downloadPage = "https://portswigger.net/burp/freedownload";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    platforms = openjdk.meta.platforms;
    hydraPlatforms = [];
    maintainers = with maintainers; [ madonius ];
  };
}
