{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nq";
  version = "0.4";
  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "nq";
    rev = "v${version}";
    sha256 = "sha256-UfCeHwOD+tG6X2obW64DYZr6j90yh1Yl7My4ur+sqmk=";
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
    maintainers = with maintainers; [ cstrahan ];
  };
}
