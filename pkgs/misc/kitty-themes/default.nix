{ fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "kitty-themes";
  version = "unstable-2022-08-11";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = pname;
    rev = "72cf0dc4338ab1ad85f5ed93fdb13318916cae14";
    sha256 = "d9mO2YqA7WD2dTPsmNeQg2dUR/iv2T/l7yxrt6WKX60=";
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
