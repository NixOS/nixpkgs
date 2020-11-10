{ stdenv, fetchurl, apr, jdk, openssl }:

stdenv.mkDerivation rec {
  pname = "tomcat-native";
  version = "1.2.25";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-connectors/native/${version}/source/${pname}-${version}-src.tar.gz";
    sha512 = "e121c0a18c51b5f952833df44c3a0add1f9a6e1b61e300abbafa0bc7e8f32296e64c9f81e9ad7389c1bd24abc40739e4726a56158d08e33b7ef00e5fa8a1d33d";
  };

  sourceRoot = "${pname}-${version}-src/native";

  buildInputs = [ apr jdk openssl ];

  configureFlags = [
    "--with-apr=${apr.dev}"
    "--with-java-home=${jdk}"
    "--with-ssl=${openssl.dev}"
  ];

  meta = with stdenv.lib; {
    description = "An optional component for use with Apache Tomcat that allows Tomcat to use certain native resources for performance, compatibility, etc";
    homepage = "https://tomcat.apache.org/native-doc/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aanderse ];
  };
}
