{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gti-${version}";
  version = "2016-12-07";

  src = fetchFromGitHub {
    owner = "rwos";
    repo = "gti";
    rev = "d78001bd5b4b6f6ad853b4ec810e9a1ecde1ee32";
    sha256 = "0449h9m16x542fy6gmhqqkvkg7z7brxw5vmb85nkk1gdlr9pl1mr";
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
