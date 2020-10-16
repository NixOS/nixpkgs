{ stdenv, fetchurl, jre, writeShellScript, chromium, unzip }:

let
  version = "2020.9.2";
  jar = fetchurl {
    name = "burpsuite.jar";
    url = "https://portswigger.net/Burp/Releases/Download?productId=100&version=${version}&type=Jar";
    sha256 = "d4a3abd973ae79fb1c21926dd1323d6d74763fa59bbc70d0105eccf7f41811ee";
  };
  launcher = writeShellScript "burpsuite-launcher" ''
    eval "$(${unzip}/bin/unzip -p ${jar} chromium.properties)"
    mkdir -p "$HOME/.BurpSuite/burpbrowser/$linux64"
    ln -sf "${chromium}/bin/chromium" "$HOME/.BurpSuite/burpbrowser/$linux64/chrome"
    exec ${jre}/bin/java -jar ${jar} "$@"
  '';
in stdenv.mkDerivation {
  pname = "burpsuite";
  inherit version;
  buildCommand = ''
    mkdir -p $out/bin
    cp "${launcher}" $out/bin/burpsuite
  '';

  preferLocalBuild = true;

  meta = {
    description = "An integrated platform for performing security testing of web applications";
    longDescription = ''
      Burp Suite is an integrated platform for performing security testing of web applications.
      Its various tools work seamlessly together to support the entire testing process, from
      initial mapping and analysis of an application's attack surface, through to finding and
      exploiting security vulnerabilities.
    '';
    homepage = "https://portswigger.net/burp/";
    downloadPage = "https://portswigger.net/burp/freedownload";
    license = [ stdenv.lib.licenses.unfree ];
    platforms = jre.meta.platforms;
    hydraPlatforms = [];
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
  };
}
