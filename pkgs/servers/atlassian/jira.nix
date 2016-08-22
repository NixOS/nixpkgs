{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "atlassian-jira-${version}";
  version = "6.4.14";

  src = fetchurl {
    url = "https://downloads.atlassian.com/software/jira/downloads/${name}.tar.gz";
    sha256 = "09a425hs5fn9riilhnp9bljdviky2hnc3fizvhj3ym2yi9niga3p";
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
}
