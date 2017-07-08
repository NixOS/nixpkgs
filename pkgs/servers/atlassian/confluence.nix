{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "atlassian-confluence-${version}";
  version = "6.2.2";

  src = fetchurl {
    url = "https://www.atlassian.com/software/confluence/downloads/binary/${name}.tar.gz";
    sha256 = "1fpn799382m8x7b0s3w4mxzlhy1s62ya287i622gbadqscprhagg";
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
    patchShebangs $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Team collaboration software written in Java and mainly used in corporate environments";
    homepage = https://www.atlassian.com/software/confluence;
    license = licenses.unfree;
    maintainers = with maintainers; [ fpletz globin ];
  };
}
