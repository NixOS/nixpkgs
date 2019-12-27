{ stdenv, fetchurl, alsaLib, libopus, ortp, bctoolbox }:

stdenv.mkDerivation rec {
  pname = "trx";
  version = "0.4";

  src = fetchurl {
    url = "https://www.pogo.org.uk/~mark/trx/releases/${pname}-${version}.tar.gz";
    sha256 = "1wsrkbqc090px8i9p8awz38znxjcqjb1dzjjdd8xkjmiprayjhkl";
  };

  buildInputs = [ alsaLib libopus ortp bctoolbox ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A simple toolset for broadcasting live audio using RTP/UDP and Opus";
    homepage = http://www.pogo.org.uk/~mark/trx/;
    license = licenses.gpl2;
    maintainers = [ maintainers.hansjoergschurr ];
    platforms = platforms.linux;
  };
}
