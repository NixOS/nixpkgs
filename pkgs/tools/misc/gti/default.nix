{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gti-${version}";
  version = "2015-05-21";

  src = fetchFromGitHub {
    owner = "rwos";
    repo = "gti";
    rev = "edaac795b0b0ff01f2347789f96c740c764bf376";
    sha256 = "1wki7d61kcmv9s3xayky9cz84qa773x3y1z88y768hq8ifwadcbn";
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
