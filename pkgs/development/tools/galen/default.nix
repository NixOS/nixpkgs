{ stdenv, fetchurl, jdk, unzip }:

stdenv.mkDerivation rec {
  pname = "galen";
  version = "2.2.3";
  name = "${pname}-${version}";

  inherit jdk;

  src = fetchurl {
    url = "https://github.com/galenframework/galen/releases/download/galen-${version}/galen-bin-${version}.zip";
    sha256 = "13kvxbw68g82rv8bp9g4fkrrsd7nag1a4bspilqi2wnxc51c8mqq";
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
