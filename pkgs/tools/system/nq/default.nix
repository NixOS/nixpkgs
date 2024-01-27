{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nq";
  version = "0.5";
  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "nq";
    rev = "v${version}";
    sha256 = "sha256-g14t2Wy2GwiqnfEDiLAPGehzUgK6mLC+5PAZynez62s=";
  };
  makeFlags = [ "PREFIX=$(out)" ];
  postPatch = ''
    sed -i tq \
      -e 's|\bnq\b|'$out'/bin/nq|g' \
      -e 's|\bfq\b|'$out'/bin/fq|g'
  '';
  meta = with lib; {
    description = "Unix command line queue utility";
    homepage = "https://github.com/chneukirchen/nq";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
