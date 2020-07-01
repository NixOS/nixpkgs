{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dadadodo";
  version = "1.04";

  src = fetchurl {
    url = "https://www.jwz.org/dadadodo/${pname}-${version}.tar.gz";
    sha256 = "1pzwp3mim58afjrc92yx65mmgr1c834s1v6z4f4gyihwjn8bn3if";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp dadadodo $out/bin
  '';

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "Markov chain-based text generator";
    homepage = "http://www.jwz.org/dadadodo";
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
