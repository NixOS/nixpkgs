{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "riemann";
  version = "0.3.10";

  src = fetchurl {
    url = "https://github.com/riemann/riemann/releases/download/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-dkIdx+9Rq3paDGHKuwO6RsrQ1u2mvRnncEyOIHqOBRM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    substituteInPlace bin/riemann --replace '$top/lib/riemann.jar' "$out/share/java/riemann.jar"

    mkdir -p $out/share/java $out/bin $out/etc
    mv lib/riemann.jar $out/share/java/
    mv bin/riemann $out/bin/
    mv etc/riemann.config $out/etc/

    wrapProgram "$out/bin/riemann" --prefix PATH : "${jre}/bin"
  '';

  meta = with lib; {
    homepage = "http://riemann.io/";
    description = "A network monitoring system";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = [];
  };
}
