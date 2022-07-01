{ fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "kitty-themes";
  version = "unstable-2022-05-04";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = pname;
    rev = "fb48041b0ff5ce60e8f10e7067a407ad99a4862e";
    sha256 = "/JCLty73YHsTkNxZP6EwhhoiHi2HjtyMZphAPhHe5h0=";
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
