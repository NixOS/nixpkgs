{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "lr-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${version}";
    sha256 = "1536d723dm50gxgpf8i9yij8mr0csh662ljhs5bmz0945jwfbx4n";
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
