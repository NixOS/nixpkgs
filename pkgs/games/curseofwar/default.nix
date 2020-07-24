{ stdenv
, fetchFromGitHub
, fetchpatch
, ncurses
, SDL
}:

stdenv.mkDerivation rec {
  pname = "curseofwar";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "a-nikolaev";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bj3lv5vrnwzzkgj31pyf1lzkz10qphvzlfz7a3j4plqkczjq92y";
  };

  patches = [(fetchpatch {
    # Pull request #40: https://github.com/a-nikolaev/curseofwar/pull/40
    name = "prefix-independent-data";
    url = "https://github.com/fgaz/curseofwar/commit/947dea527b2bf4c6e107b8e9c66f4c4fd775b6f9.patch";
    sha256 = "0ak5igaxmbavkbl8101xx6gswhwgzm5f6wyplwapgh7cylnclc61";
  })];

  buildInputs = [
    ncurses
    SDL
  ];

  makeFlags = (if isNull SDL then [] else [ "SDL=yes" ]) ++ [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A fast-paced action strategy game";
    homepage = "https://a-nikolaev.github.io/curseofwar/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

