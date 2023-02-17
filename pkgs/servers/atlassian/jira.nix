{ stdenv
, lib
, fetchurl
, gawk
, enableSSO ? false
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "atlassian-jira";
  version = "9.4.0";

  src = fetchurl {
    url = "https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${version}.tar.gz";
    sha256 = "sha256-PParjwX7/7kMd8nMn50Shpur8+f0TTEgeSn85B3BrsI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    mv conf/server.xml conf/server.xml.dist
    ln -sf /run/atlassian-jira/server.xml conf/server.xml
    rm -r logs; ln -sf /run/atlassian-jira/logs/ .
    rm -r work; ln -sf /run/atlassian-jira/work/ .
    rm -r temp; ln -sf /run/atlassian-jira/temp/ .
    substituteInPlace bin/check-java.sh \
      --replace "awk" "${gawk}/bin/gawk"
  '' + lib.optionalString enableSSO ''
    substituteInPlace atlassian-jira/WEB-INF/classes/seraph-config.xml \
      --replace com.atlassian.jira.security.login.JiraSeraphAuthenticator \
                com.atlassian.jira.security.login.SSOSeraphAuthenticator
  '';

  installPhase = ''
    cp -rva . $out
  '';

  meta = with lib; {
    description = "Proprietary issue tracking product, also providing project management functions";
    homepage = "https://www.atlassian.com/software/jira";
    license = licenses.unfree;
    maintainers = with maintainers; [ globin ciil megheaiulian techknowlogick ma27 ];
  };
}
