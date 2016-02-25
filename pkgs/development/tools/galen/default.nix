{ stdenv, fetchurl, jdk, unzip }:

stdenv.mkDerivation rec {
  pname = "galen";
  version = "2.2.1";
  name = "${pname}-${version}";

  inherit jdk;

  src = fetchurl {
    url = "https://github.com/galenframework/galen/releases/download/galen-2.2.1/galen-bin-${version}.zip";
    sha256 = "0zwrh3bxcgkwip6z9lvy3hn53kfr99cdij64c57ff8d95xilclhb";
  };

  buildInputs = [ unzip ];
  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
  mkdir -p $out/bin
  '';

  installPhase = ''
  cat galen | sed -e "s,java,$jdk/bin/java," > $out/bin/galen
  chmod +x $out/bin/galen
  cp galen.jar $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = http://galenframework.com;
    description = "Automated layout testing for websites";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
