{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "noip-2.1.9-1";

  src = fetchurl {
    url = http://www.noip.com/client/linux/noip-duc-linux.tar.gz;
    sha256 = "82b9bafab96a0c53b21aaef688bf70b3572e26217b5e2072bdb09da3c4a6f593";
  };

  makeFlags = [ "PREFIX=\${out}" ];
  installPhase =
    ''
      mkdir -p $out/bin
      cp noip2 $out/bin
    '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Dynamic DNS daemon for no-ip accounts";
    homepage = http://noip.com/download?page=linux;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.iand675 ];
    platforms = platforms.linux;
  };
}
