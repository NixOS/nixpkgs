{ lib, stdenv, fetchurl, apr, jdk, openssl }:

stdenv.mkDerivation rec {
  pname = "tomcat-native";
  version = "2.0.8";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-connectors/native/${version}/source/${pname}-${version}-src.tar.gz";
    hash = "sha256-x8U4L8taZHpc5v7QuWch6UGY+i9XJc9RJPW2URsF3+8=";
  };

  sourceRoot = "${pname}-${version}-src/native";

  buildInputs = [ apr jdk openssl ];

  configureFlags = [
    "--with-apr=${apr.dev}"
    "--with-java-home=${jdk}"
    "--with-ssl=${openssl.dev}"
  ];

  meta = with lib; {
    description = "Optional component for use with Apache Tomcat that allows Tomcat to use certain native resources for performance, compatibility, etc";
    homepage = "https://tomcat.apache.org/native-doc/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aanderse ];
  };
}
