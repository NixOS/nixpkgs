{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "nq-${version}";
  version = "0.1";
  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "nq";
    rev = "v${version}";
    sha256 = "17n0yqhpsys3s872ki5rf82ky73ylahz6xi9x0rfrv7fqr5nzsz4";
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
