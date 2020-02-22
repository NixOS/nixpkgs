{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nq";
  version = "0.3.1";
  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "nq";
    rev = "v${version}";
    sha256 = "1db96ykz35r273jyhf7cdknqk4p2jj9l8gbz7pjy1hq4pb6ffk99";
  };
  makeFlags = [ "PREFIX=$(out)" ];
  postPatch = ''
    sed -i tq \
      -e 's|\bfq\b|'$out'/bin/fq|g' \
      -e 's|\bnq\b|'$out'/bin/nq|g'
  '';
  meta = with lib; {
    description = "Unix command line queue utility";
    homepage = https://github.com/chneukirchen/nq;
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
