{
  lib,
  stdenv,
  fetchurl,
  apr,
  jdk,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "tomcat-native";
  version = "2.0.13";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-connectors/native/${version}/source/${pname}-${version}-src.tar.gz";
    hash = "sha256-TwAsSTxQICeayqdhqYmWS6VpVHk6XAcYvHCWnIuxHdU=";
  };

  sourceRoot = "${pname}-${version}-src/native";

  buildInputs = [
    apr
    jdk
    openssl
  ];

  configureFlags = [
    "--with-apr=${apr.dev}"
    "--with-java-home=${jdk}"
    "--with-ssl=${openssl.dev}"
  ];

  meta = {
    description = "Optional component for use with Apache Tomcat that allows Tomcat to use certain native resources for performance, compatibility, etc";
    homepage = "https://tomcat.apache.org/native-doc/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aanderse ];
  };
}
