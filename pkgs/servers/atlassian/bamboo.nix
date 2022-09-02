{ stdenvNoCC, lib, fetchurl, mysql_jdbc
, withMysql ? true
}:


stdenvNoCC.mkDerivation rec {
  pname = "atlassian-bamboo";
  version = "8.1.4";

  src = fetchurl {
    url = "https://product-downloads.atlassian.com/software/bamboo/downloads/atlassian-bamboo-${version}.tar.gz";
    sha256 = "sha256-v30Q3yGKkpHQFitOcH764SE6KuCdUJWn50buY7pb/Ng=";
  };

  buildPhase = ''
    echo "bamboo.home=/run/bamboo/home" > atlassian-bamboo/WEB-INF/classes/bamboo-init.properties
    mv conf/server.xml conf/server.xml.dist
    ln -sf /run/atlassian-bamboo/server.xml conf/server.xml
    rm -r logs; ln -sf /run/atlassian-bamboo/logs/ .
    rm -r temp; ln -sf /run/atlassian-bamboo/temp/ .
    rm -r work; ln -sf /run/atlassian-bamboo/work/ .
  '' + lib.optionalString withMysql ''
    cp -v ${mysql_jdbc}/share/java/*jar atlassian-bamboo/lib/
  '';

  installPhase = ''
    cp -rva . $out
    patchShebangs $out/bin
  '';

  meta = with lib; {
    description = "Bamboo Data Center is a continuous delivery server.";
    homepage = "https://www.atlassian.com/software/bamboo";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ techknowlogick ];
  };
}
