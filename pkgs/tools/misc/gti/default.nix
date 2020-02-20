{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gti";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "rwos";
    repo = "gti";
    rev = "v${version}";
    sha256 = "1jivnjswlhwjfg5v9nwfg3vfssvqbdxxf9znwmfb5dgfblg9wxw9";
  };

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man6
    cp gti $out/bin
    cp gti.6 $out/share/man/man6
  '';

  meta = with stdenv.lib; {
    homepage = http://r-wos.org/hacks/gti;
    license = licenses.mit;
    description = "Humorous typo-based git runner; drives a car over the terminal";
    maintainers = with maintainers; [ fadenb ];
    platforms = platforms.unix;
  };
}
