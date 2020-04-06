{ stdenv, fetchurl, jre, runtimeShell }:

let
  version = "2020.1";
  jar = fetchurl {
    name = "burpsuite.jar";
    url = "https://portswigger.net/Burp/Releases/Download?productId=100&version=${version}&type=Jar";
    sha256 = "12awfy0f8fyqjc0kza1gkmdx1g8bniw1xqaps2dhjimi6s0lq5jx";
  };
  launcher = ''
    #!${runtimeShell}
    exec ${jre}/bin/java -jar ${jar} "$@"
  '';
in stdenv.mkDerivation {
  pname = "burpsuite";
  inherit version;
  buildCommand = ''
    mkdir -p $out/bin
    echo "${launcher}" > $out/bin/burpsuite
    chmod +x $out/bin/burpsuite
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
    homepage = https://portswigger.net/burp/;
    downloadPage = "https://portswigger.net/burp/freedownload";
    license = [ stdenv.lib.licenses.unfree ];
    platforms = jre.meta.platforms;
    hydraPlatforms = [];
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
  };
}
