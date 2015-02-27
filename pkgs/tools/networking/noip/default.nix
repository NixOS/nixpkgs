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
      if [ ! -d "$out/bin" ]; then mkdir -p $out/bin;fi
      cp noip2 $out/bin
    '';

  enableParallelBuilding = true;
}
