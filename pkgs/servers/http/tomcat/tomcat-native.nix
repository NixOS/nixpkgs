{ lib, stdenv, fetchurl, apr, jdk, openssl }:

stdenv.mkDerivation rec {
  pname = "tomcat-native";
  version = "1.2.26";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-connectors/native/${version}/source/${pname}-${version}-src.tar.gz";
    sha512 = "319lrb0b5vvm2m46rdz2zbicisijvim6948ghz0mypck6f419yjr68j8rpmxpckscaj0ghmbq3p28jpxbjpig84ygy0m63cvgpxknfa";
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
