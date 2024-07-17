{
  lib,
  stdenv,
  fetchurl,
  apacheHttpd,
  jdk,
}:

stdenv.mkDerivation rec {
  pname = "mod_jk";
  version = "1.2.49";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-connectors/jk/tomcat-connectors-${version}-src.tar.gz";
    hash = "sha256-Q8sCg8koeOnU7xEGMdvSvra1VxPBJ84EMZCyswh1fpw=";
  };

  configureFlags = [
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
    "--with-java-home=${jdk}"
  ];

  setSourceRoot = ''
    sourceRoot=$(echo */native)
  '';

  installPhase = ''
    mkdir -p $out/modules
    cp apache-2.0/mod_jk.so $out/modules
  '';

  buildInputs = [
    apacheHttpd
    jdk
  ];

  meta = with lib; {
    description = "Provides web server plugins to connect web servers with Tomcat";
    homepage = "https://tomcat.apache.org/download-connectors.cgi";
    changelog = "https://tomcat.apache.org/connectors-doc/miscellaneous/changelog.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ anthonyroussel ];
    platforms = platforms.unix;
  };
}
