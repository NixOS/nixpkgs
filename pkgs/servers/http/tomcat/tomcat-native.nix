{ lib, stdenv, fetchurl, apr, jdk, openssl }:

stdenv.mkDerivation rec {
  pname = "tomcat-native";
  version = "2.0.6";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-connectors/native/${version}/source/${pname}-${version}-src.tar.gz";
    hash = "sha256-vmF8V26SO2B50LdSBtcG2ifdBDzr9Qv7leOpwKodGjU=";
  };

  sourceRoot = "${pname}-${version}-src/native";

  buildInputs = [ apr jdk openssl ];

  configureFlags = [
    "--with-apr=${apr.dev}"
    "--with-java-home=${jdk}"
    "--with-ssl=${openssl.dev}"
  ];

  meta = with lib; {
    description = "An optional component for use with Apache Tomcat that allows Tomcat to use certain native resources for performance, compatibility, etc";
    homepage = "https://tomcat.apache.org/native-doc/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aanderse ];
  };
}
