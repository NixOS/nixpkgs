{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "atlassian-jira-${version}";
  version = "7.3.7";

  src = fetchurl {
    url = "https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${version}.tar.gz";
    sha256 = "1ixnnw3yj2ip9ndr9pwxcmdy8gaixkmp517ahg3w8xzymr8wh2qp";
  };

  phases = [ "unpackPhase" "buildPhase" "installPhase" "fixupPhase" ];

  buildPhase = ''
    mv conf/server.xml conf/server.xml.dist
    ln -sf /run/atlassian-jira/server.xml conf/server.xml
    rm -r logs; ln -sf /run/atlassian-jira/logs/ .
    rm -r work; ln -sf /run/atlassian-jira/work/ .
    rm -r temp; ln -sf /run/atlassian-jira/temp/ .
  '';

  installPhase = ''
    cp -rva . $out
  '';

  meta = with stdenv.lib; {
    description = "Proprietary issue tracking product, also providing project management functions";
    homepage = https://www.atlassian.com/software/jira;
    license = licenses.unfree;
    maintainers = with maintainers; [ fpletz globin ];
  };
}
