{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "redir-${version}";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "redir";
    rev = "v${version}";
    sha256 = "015vxpy6n7xflkq0lgls4f4vw7ynvv2635bwykzglin3v5ssrm2k";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "A TCP port redirector for UNIX";
    homepage = https://github.com/troglobit/redir;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ globin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
