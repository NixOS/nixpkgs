{ stdenv, fetchurl, apr, jdk, openssl }:

stdenv.mkDerivation rec {
  pname = "tomcat-native";
  version = "1.2.23";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-connectors/native/${version}/source/${pname}-${version}-src.tar.gz";
    sha512 = "89a0363961d322a87f4e752f4727f54f28ac6e4ad10fa21b6b7390c62b041d4068672d95495d9233c1cad7d6c1dc3c85fbd0186894085b3b94e476876af160ee";
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
