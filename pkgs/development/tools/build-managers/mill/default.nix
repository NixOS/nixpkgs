{ stdenv, lib, fetchurl, makeWrapper, jre, gnused }:

stdenv.mkDerivation rec {
  name = "mill-${version}";
  version = "0.2.3";

   src = fetchurl {
     url = "https://github.com/lihaoyi/mill/releases/download/${version}/${version}";
     sha256 = "15rrfnsrabq2gk5f33dviq1g2ydg1f61x9w5s5wgahvphwpxaik9";
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
