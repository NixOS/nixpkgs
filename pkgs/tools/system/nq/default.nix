{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "nq-${version}";
  version = "0.2.2";
  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "nq";
    rev = "v${version}";
    sha256 = "0348r3j5y445psm8lj35z100cfvbfp05s7ji6bxd0gg4n66l2c4l";
  };
  makeFlags = "PREFIX=$(out)";
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
