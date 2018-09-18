{ stdenv, lib, fetchurl
, enableSSO ? false
, crowdProperties ? null
}:

stdenv.mkDerivation rec {
  name = "atlassian-confluence-${version}";
  version = "6.11.1";

  src = fetchurl {
    url = "https://www.atlassian.com/software/confluence/downloads/binary/${name}.tar.gz";
    sha256 = "0sp1ggllvxdz0pf409yyil1x9dah1jyqspknfzgivkmwhcqj7brr";
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
  '' + lib.optionalString enableSSO ''
    substituteInPlace confluence/WEB-INF/classes/seraph-config.xml \
      --replace com.atlassian.confluence.user.ConfluenceAuthenticator\
                com.atlassian.confluence.user.ConfluenceCrowdSSOAuthenticator
  '' + lib.optionalString (crowdProperties != null) ''
    cat <<EOF > confluence/WEB-INF/classes/crowd.properties
    ${crowdProperties}
    EOF
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
