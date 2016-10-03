{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "f3-${version}";
  version = "6.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "AltraMayor";
    repo = "f3";
    rev = "v${version}";
    sha256 = "1azi10ba0h9z7m0gmfnyymmfqb8380k9za8hn1rrw1s442hzgnz2";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  patchPhase = "sed -i 's/-oroot -groot//' Makefile";

  meta = {
    description = "Fight Flash Fraud";
    homepage = http://oss.digirati.com.br/f3/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ makefu ];
  };
}
