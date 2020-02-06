{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "riemann";
  version = "0.3.5";

  src = fetchurl {
    url = "https://github.com/riemann/riemann/releases/download/${version}/${pname}-${version}.tar.bz2";
    sha256 = "1d7v2lg1b7z6v0qckq70nzqpqcs90v29laizsf8ghyj113ips3rc";
  };

  nativeBuildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    substituteInPlace bin/riemann --replace '$top/lib/riemann.jar' "$out/share/java/riemann.jar"

    mkdir -p $out/share/java $out/bin $out/etc
    mv lib/riemann.jar $out/share/java/
    mv bin/riemann $out/bin/
    mv etc/riemann.config $out/etc/

    wrapProgram "$out/bin/riemann" --prefix PATH : "${jre}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = http://riemann.io/;
    description = "A network monitoring system";
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = [];
  };
}
