{ stdenv, fetchurl, jre, runtimeShell }:

let
  version = "1.7.36";
  jar = fetchurl {
    name = "burpsuite.jar";
    url = "https://portswigger.net/Burp/Releases/Download?productId=100&version=${version}&type=Jar";
    sha256 = "12m4fn04yd89r6x4m4yd668p5v0bs9b1h6p239bjj11ykyi3g51a";
  };
  launcher = ''
    #!${runtimeShell}
    exec ${jre}/bin/java -jar ${jar} "$@"
  '';
in stdenv.mkDerivation {
  name = "burpsuite-${version}";
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
    maintainers = [ stdenv.lib.maintainers.bennofs ];
  };
}
