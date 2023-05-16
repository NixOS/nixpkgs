<<<<<<< HEAD
{ stdenv, lib, fetchFromGitHub, gettext, ncurses, asciidoc }:

stdenv.mkDerivation rec {
  pname = "yash";
  version = "2.55";

  src = fetchFromGitHub {
    owner = "magicant";
    repo = pname;
    rev = version;
    hash = "sha256-raTIqklo69JEuhzdWUK3uywuLjqeQJCJ9nvnLRxlGr4=";
  };

  strictDeps = true;
  nativeBuildInputs = [ asciidoc gettext ];
  buildInputs = [ ncurses ] ++ lib.optionals stdenv.isDarwin [ gettext ];
=======
{ stdenv, lib, fetchurl, gettext, ncurses }:

stdenv.mkDerivation rec {
  pname = "yash";
  version = "2.53";

  src = fetchurl {
    url = "https://osdn.net/dl/yash/yash-${version}.tar.xz";
    hash = "sha256-5DDuhF39dxHE+GTVGN+H3Xi0BWAyfElPWczEcxWFMF0=";
  };

  strictDeps = true;
  buildInputs = [ gettext ncurses ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://yash.osdn.jp/index.html.en";
    description = "Yet another POSIX-compliant shell";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qbit ];
    platforms = platforms.all;
  };

  passthru.shellPath = "/bin/yash";
}
