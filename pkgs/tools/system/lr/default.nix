{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "lr-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${version}";
    sha256 = "171h353238s9wmhirvs2yc1151vds83a71p7wgn96wa3jpl248by";
  };

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    homepage = https://github.com/chneukirchen/lr;
    description = "List files recursively";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.globin ];
  };
}
