{ stdenvNoCC, lib, fetchurl, mysql_jdbc ? null
, enableSSO ? false
, crowdProperties ? null
, withMysql ? true
}:

assert withMysql -> (mysql_jdbc != null);

let
  optionalWarning = cond: msg:
    if cond then lib.warn msg
    else lib.id;
in

optionalWarning (crowdProperties != null) "Using `crowdProperties` is deprecated!"
(stdenvNoCC.mkDerivation rec {
  pname = "atlassian-confluence";
  version = "7.19.1";

  src = fetchurl {
    url = "https://product-downloads.atlassian.com/software/confluence/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-icfyxuS6chh3ibXZ0V9YYB0oCDd9o5rmcDC5Rbr0tOQ=";
  };

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
  '' + lib.optionalString withMysql ''
    cp -v ${mysql_jdbc}/share/java/*jar confluence/WEB-INF/lib/
  '';

  installPhase = ''
    cp -rva . $out
    patchShebangs $out/bin
  '';

  meta = with lib; {
    description = "Team collaboration software written in Java and mainly used in corporate environments";
    homepage = "https://www.atlassian.com/software/confluence";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ globin willibutz ciil techknowlogick ma27 ];
  };
})
