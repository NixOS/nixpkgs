{ stdenv, fetchurl, jre8, unzip }:

stdenv.mkDerivation rec {
  pname = "galen";
  version = "2.3.0";
  name = "${pname}-${version}";

  inherit jre8;

  src = fetchurl {
    url = "https://github.com/galenframework/galen/releases/download/galen-${version}/galen-bin-${version}.zip";
    sha256 = "10z7vh3jiq7kbzzp3j0354swkr4xxz9qimi5c5bddbiy671k6cra";
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
