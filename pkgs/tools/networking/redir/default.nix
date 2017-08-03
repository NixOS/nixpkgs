{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "redir-${version}";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "redir";
    rev = "v${version}";
    sha256 = "1m05dchi15bzz9zfdb7jg59624sx4khp5zq0wf4pzr31s64f69cx";
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
