{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "paxtest-${version}";
  version = "0.9.14";

  src = fetchurl {
    url    = "https://www.grsecurity.net/~spender/${name}.tar.gz";
    sha256 = "0j40h3x42k5mr5gc5np4wvr9cdf9szk2f46swf42zny8rlgxiskx";
  };

  buildPhase = ''
    make $makeFlags RUNDIR=$out/bin/ linux
  '';

  installPhase = ''
    mkdir -p $out/bin
    find . -executable -exec cp {} $out/bin \;
  '';

  meta = with stdenv.lib; {
    description = "Test various memory protection measures";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainer  = [ maintainers.copumpkin ];
  };
}

