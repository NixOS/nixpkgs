{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "riemann-${version}";
  version = "0.2.12";

  src = fetchurl {
    url = "https://github.com/riemann/riemann/releases/download/${version}/${name}.tar.bz2";
    sha256 = "1x57gi301rg6faxm4q5scq9dpp0v9nqiwjpsgigdb8whmjr1zwkr";
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
    maintainers = [ maintainers.rickynils ];
  };
}
