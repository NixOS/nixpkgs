{ lib, stdenv, fetchurl, jdk11, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "burpsuite";
  version = "2022.2.4";

  src = fetchurl {
    name = "burpsuite.jar";
    urls = [
      "https://portswigger.net/Burp/Releases/Download?productId=100&version=${version}&type=Jar"
      "https://web.archive.org/web/https://portswigger.net/Burp/Releases/Download?productId=100&version=${version}&type=Jar"
    ];
    sha256 = "f0027e5736af812c384d34a7978480bb4191b77fe873600d9aff8d9763b0166b";
  };

  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${jdk11}/bin/java $out/bin/burpsuite --add-flags '-jar ${src}'

    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];
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
    platforms = jdk11.meta.platforms;
    hydraPlatforms = [];
    maintainers = with maintainers; [ bennofs ];
  };
}
