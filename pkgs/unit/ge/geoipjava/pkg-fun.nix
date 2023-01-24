{lib, stdenv, fetchurl, jdk, unzip}:

stdenv.mkDerivation rec {
  pname = "GeoIPJava";
  version = "1.2.5";

  src = fetchurl {
    url = "https://geolite.maxmind.com/download/geoip/api/java/GeoIPJava-${version}.zip";
    sha256 = "1gb2d0qvvq7xankz7l7ymbr3qprwk9bifpy4hlgw0sq4i6a55ypd";
  };
  nativeBuildInputs = [ unzip ];
  buildInputs = [ jdk ];
  buildPhase =
    ''
      cd source
      javac $(find . -name \*.java)
      jar cfv maxmindgeoip.jar $(find . -name \*.class)
    '';
  installPhase =
    ''
      mkdir -p $out/share/java
      cp maxmindgeoip.jar $out/share/java
    '';
  meta = {
    description = "GeoIP Java API";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.unix;
  };
}
