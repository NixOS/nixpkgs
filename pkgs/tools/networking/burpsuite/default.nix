{ stdenv, fetchurl, jdk12, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "burpsuite";
  version = "2.1.07";
  jar = fetchurl {
    name = "burpsuite.jar";
    url = "https://portswigger.net/Burp/Releases/Download?productId=100&version=${version}&type=Jar";
    sha256 = "23ce776dcc1dcf3d3bf332180d112fd1a68345747e2ffc282a2d515efbbc2120";
  };
  launcher = ''
    #!${runtimeShell}
    exec ${jdk12}/bin/java -jar ${jar} "$@"
  '';
  buildCommand = ''
    mkdir -p $out/bin
    echo "${launcher}" > $out/bin/burpsuite
    chmod +x $out/bin/burpsuite
  '';

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description = "An integrated platform for performing security testing of web applications";
    longDescription = ''
      Burp Suite is an integrated platform for performing security testing of web applications.
      Its various tools work seamlessly together to support the entire testing process, from
      initial mapping and analysis of an application's attack surface, through to finding and
      exploiting security vulnerabilities.
    '';
    homepage = "https://portswigger.net/burp/";
    downloadPage = "https://portswigger.net/burp/communitydownload";
    license = [ licenses.unfree ];
    platforms = jdk12.meta.platforms;
    hydraPlatforms = [];
    maintainers = [ maintainers.bennofs ];
  };
}
