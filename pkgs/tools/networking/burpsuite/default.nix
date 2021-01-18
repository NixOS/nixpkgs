{ lib, stdenv, fetchurl, jdk11, runtimeShell }:

let
  version = "2020.12.1";
  jar = fetchurl {
    name = "burpsuite.jar";
    url = "https://portswigger.net/Burp/Releases/Download?productId=100&version=${version}&type=Jar";
    sha256 = "1vdxwasvcyxyyidq3cfjphzkir358sxikgvxgl36czylap4hzjh1";
  };
  launcher = ''
    #!${runtimeShell}
    exec ${jdk11}/bin/java -jar ${jar} "$@"
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
    homepage = "https://portswigger.net/burp/";
    downloadPage = "https://portswigger.net/burp/freedownload";
    license = [ lib.licenses.unfree ];
    platforms = jdk11.meta.platforms;
    hydraPlatforms = [];
    maintainers = with lib.maintainers; [ bennofs ];
  };
}
