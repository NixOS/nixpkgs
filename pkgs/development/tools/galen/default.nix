{ stdenv, fetchurl, jre8, unzip }:

stdenv.mkDerivation rec {
  pname = "galen";
  version = "2.3.7";
  name = "${pname}-${version}";

  inherit jre8;

  src = fetchurl {
    url = "https://github.com/galenframework/galen/releases/download/galen-${version}/galen-bin-${version}.zip";
    sha256 = "045y1s4n8jd52jnk9kwd0k4x3yscvcfsf2rxzn0xngvn9nkw2g65";
  };

  buildInputs = [ unzip ];

  buildPhase = ''
  mkdir -p $out/bin
  '';

  installPhase = ''
  cat galen | sed -e "s,java,$jre8/bin/java," > $out/bin/galen
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
