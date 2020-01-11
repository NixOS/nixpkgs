{stdenv, lib, fetchFromGitHub, libX11, autoreconfHook }:

stdenv.mkDerivation {
  pname = "xsel-unstable";

  version = "2019-08-21";

  src = fetchFromGitHub {
    owner = "kfish";
    repo = "xsel";
    rev = "ef01f3c72a195dbce682184c842b81b17d7d7ad1";
    sha256 = "191qa6022b7nww3bicfxpgp4d9x6c8s3sgixi780383ghkxds08c";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libX11 ];

  meta = with lib; {
    description = "Command-line program for getting and setting the contents of the X selection";
    homepage = http://www.kfish.org/software/xsel;
    license = licenses.mit;
    maintainers = [ maintainers.cstrahan ];
    platforms = lib.platforms.unix;
  };
}
