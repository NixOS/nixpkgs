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

  meta = with lib; {
    homepage = "https://yash.osdn.jp/index.html.en";
    description = "Yet another POSIX-compliant shell";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qbit ];
    platforms = platforms.all;
  };

  passthru.shellPath = "/bin/yash";
}
