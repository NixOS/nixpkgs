{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "atlassian-confluence-${version}";
  version = "5.10.2";

  src = fetchurl {
    url = "https://www.atlassian.com/software/confluence/downloads/binary/${name}.tar.gz";
    sha256 = "0f7v2fb4408zj84vh8m9axlv841k312djpk3d24gsgabsmx552mb";
  };

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    echo "confluence.home=/run/confluence/home" > confluence/WEB-INF/classes/confluence-init.properties
    mv conf/server.xml conf/server.xml.dist
    ln -sf /run/confluence/home/deploy conf/Standalone
    ln -sf /run/confluence/server.xml conf/server.xml
    rm -r logs; ln -sf /run/confluence/logs/ .
    rm -r work; ln -sf /run/confluence/work/ .
    rm -r temp; ln -sf /run/confluence/temp/ .
  '';

  installPhase = ''
    cp -rva . $out
  '';
}
