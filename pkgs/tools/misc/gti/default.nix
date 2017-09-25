{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gti-${version}";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "rwos";
    repo = "gti";
    rev = "v${version}";
    sha256 = "19q3r4v22z2q1j4njap356f3mcq6kwh6v8nbbq2rw4x3cdxwdv51";
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
