{ stdenv, fetchurl, home ? "/var/lib/crowd"
, port ? 8092, proxyUrl ? null, openidPassword ? "WILL_NEVER_BE_SET" }:

stdenv.mkDerivation rec {
  pname = "atlassian-crowd";
  version = "4.0.2";

  src = fetchurl {
    url = "https://www.atlassian.com/software/crowd/downloads/binary/${pname}-${version}.tar.gz";
    sha256 = "1ndg9qb406rd239q7xycc2vdh2jd4fh9wryx1fm9493rxlncx28b";
  };

  phases = [ "unpackPhase" "buildPhase" "installPhase" "fixupPhase" ];

  buildPhase = ''
    mv apache-tomcat/conf/server.xml apache-tomcat/conf/server.xml.dist
    ln -s /run/atlassian-crowd/server.xml apache-tomcat/conf/server.xml

    rm -rf apache-tomcat/{logs,work}
    ln -s /run/atlassian-crowd/logs apache-tomcat/logs
    ln -s /run/atlassian-crowd/work apache-tomcat/work

    ln -s /run/atlassian-crowd/database database

    substituteInPlace apache-tomcat/bin/startup.sh --replace start run

    echo "crowd.home=${home}" > crowd-webapp/WEB-INF/classes/crowd-init.properties
    substituteInPlace build.properties \
      --replace "openidserver.url=http://localhost:8095/openidserver" \
                "openidserver.url=http://localhost:${toString port}/openidserver"
    substituteInPlace crowd-openidserver-webapp/WEB-INF/classes/crowd.properties \
      --replace "http://localhost:8095/" \
                "http://localhost:${toString port}/"
    sed -r -i crowd-openidserver-webapp/WEB-INF/classes/crowd.properties \
      -e 's,application.password\s+password,application.password ${openidPassword},'
  '' + stdenv.lib.optionalString (proxyUrl != null) ''
    sed -i crowd-openidserver-webapp/WEB-INF/classes/crowd.properties \
      -e 's,http://localhost:${toString port}/openidserver,${proxyUrl}/openidserver,'
  '';

  installPhase = ''
    cp -rva . $out
  '';

  meta = with stdenv.lib; {
    description = "Single sign-on and identity management tool";
    homepage = "https://www.atlassian.com/software/crowd";
    license = licenses.unfree;
    maintainers = with maintainers; [ fpletz globin ];
  };
}
