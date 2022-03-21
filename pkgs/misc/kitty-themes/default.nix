{ fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "kitty-themes";
  version = "unstable-2022-02-03";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = pname;
    rev = "337d6fcb3ad7e38544edfb8d0f6447894b7e5f58";
    sha256 = "ZP5GrT2QCdXtC5swqI0SXzIlqIcQNsxBlzEplj/hpz4=";
  };

  installPhase = ''
    mkdir -p $out/themes
    mv themes.json $out
    mv themes/*.conf $out/themes
  '';

  meta = with lib; {
    homepage = "https://github.com/kovidgoyal/kitty-themes";
    description = "Themes for the kitty terminal emulator";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ nelsonjeppesen ];
  };
}
