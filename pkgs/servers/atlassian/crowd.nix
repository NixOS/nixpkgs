{ stdenv, fetchurl, home ? "/var/lib/crowd" }:

stdenv.mkDerivation rec {
  name = "atlassian-crowd-${version}";
  version = "2.10.1";

  src = fetchurl {
    url = "https://www.atlassian.com/software/crowd/downloads/binary/${name}.tar.gz";
    sha256 = "1pl4wyqvzqb97ql23530amslrrsysi0fmmnzpihhgqhvhwf57sc6";
  };

  phases = [ "unpackPhase" "buildPhase" "installPhase" "fixupPhase" ];

  buildPhase = ''
    mv apache-tomcat/conf/server.xml apache-tomcat/conf/server.xml.dist
    ln -s /run/atlassian-crowd/server.xml apache-tomcat/conf/server.xml

    rm -rf apache-tomcat/work
    ln -s /run/atlassian-crowd/work apache-tomcat/work

    substituteInPlace apache-tomcat/bin/startup.sh --replace start run

    echo "crowd.home=${home}" > crowd-webapp/WEB-INF/classes/crowd-init.properties
  '';

  installPhase = ''
    cp -rva . $out
  '';

  meta = with stdenv.lib; {
    description = "Single sign-on and identity management tool";
    homepage = https://www.atlassian.com/software/crowd;
    license = licenses.unfree;
    maintainers = with maintainers; [ fpletz globin ];
  };
}
