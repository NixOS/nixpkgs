{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "915resolution-0.5.2";
  src = fetchurl {
    url = http://www.geocities.com/stomljen/915resolution-0.5.2.tar.gz;
    sha256 = "1m5nfzgwaglqabpm2l2mjqvigz1z0dj87cmj2pjbbzxmmpapv0lq";
  };
  buildPhase = "rm *.o 915resolution; make";
  installPhase = "mkdir -p $out/sbin; cp 915resolution $out/sbin/";

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
