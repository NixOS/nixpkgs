{ stdenv, fetchgit, alsaLib, libopus, ortp, bctoolbox }:

stdenv.mkDerivation rec {
  name = "trx-unstable-${version}";
  version = "2018-01-23";

  src = fetchgit {
    url = "http://www.pogo.org.uk/~mark/trx.git";
    rev = "66b4707a24172751a131e24d2a800496c699137f";
    sha256 = "0w0960p25944b30lkc8n4lj14xgsf0fjpmxqwlz2r8wl642bqnfm";
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
