{ stdenv, lib, fetchurl, makeWrapper, jre, gnused }:

stdenv.mkDerivation rec {
  name = "mill-${version}";
  version = "0.2.2";

   src = fetchurl {
     url = "https://github.com/lihaoyi/mill/releases/download/${version}/${version}";
     sha256 = "15fssc1d8vdwm6hnd74zdf98mg3f8yfba19ji83vwpgv7vynwkqi";
  };

  propagatedBuildInputs = [ jre ] ;
  buildInputs = [ makeWrapper gnused ] ;

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/mill
    chmod +x $out/bin/mill
    ${gnused}/bin/sed -i '0,/java/{s|java|${jre}/bin/java|}' $out/bin/mill
    ${gnused}/bin/sed -i '0,/mill.MillMain/{s|mill.MillMain|mill.MillMain --no-remote-logging|}' $out/bin/mill
  '';

  meta = with stdenv.lib; {
    homepage = http://www.lihaoyi.com/mill;
    license = licenses.mit;
    description = "A build tool for Scala, Java and more";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };

}
