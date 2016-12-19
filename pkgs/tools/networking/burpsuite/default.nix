{ stdenv, fetchurl, jre }:

let
  version = "1.7.06";
  jar = fetchurl {
    name = "burpsuite.jar";
    url = "https://portswigger.net/Burp/Releases/Download?productId=100&version=${version}&type=Jar";
    sha256 = "13x3x0la2jmm7zr66mvczzlmsy1parfibnl9s4iwi1nls4ikv7kl";
  };
  launcher = ''
    #!${stdenv.shell}
    exec ${jre}/bin/java -jar ${jar} "$@"
  '';
in stdenv.mkDerivation {
  name = "burpsuite-${version}";
  buildCommand = ''
    mkdir -p $out/bin
    echo "${launcher}" > $out/bin/burpsuite
    chmod +x $out/bin/burpsuite
  '';

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
    preferLocalBuild = true;
    platforms = jre.meta.platforms;
    hydraPlatforms = [];
    maintainers = [ stdenv.lib.maintainers.bennofs ];
  };
}
