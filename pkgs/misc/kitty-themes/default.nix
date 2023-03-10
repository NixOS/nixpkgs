{ fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "kitty-themes";
  version = "unstable-2023-01-08";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = pname;
    rev = "e0bb9d751033e82e455bf658744872c83f04b89d";
    sha256 = "sha256-ol/AWScGsskoxOEW32aGkJFgg8V6pIujoYIMQaVskWM=";
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
