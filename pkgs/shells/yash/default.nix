{ stdenv, lib, fetchFromGitHub, gettext, ncurses, asciidoc }:

stdenv.mkDerivation rec {
  pname = "yash";
  version = "2.56.1";

  src = fetchFromGitHub {
    owner = "magicant";
    repo = pname;
    rev = version;
    hash = "sha256-G4l0JmtrYaVKfQiJKTOiNWgpsKNhHtbAT0l/VboMJTc=";
  };

  strictDeps = true;
  nativeBuildInputs = [ asciidoc gettext ];
  buildInputs = [ ncurses ] ++ lib.optionals stdenv.isDarwin [ gettext ];

  meta = with lib; {
    homepage = "https://yash.osdn.jp/index.html.en";
    description = "Yet another POSIX-compliant shell";
    mainProgram = "yash";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qbit ];
    platforms = platforms.all;
  };

  passthru.shellPath = "/bin/yash";
}
