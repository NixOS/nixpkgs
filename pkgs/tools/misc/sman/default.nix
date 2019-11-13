{ stdenv
, fetchFromGitHub
, ncurses
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "sman";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jtojnar";
    repo = pname;
    rev = "v${version}";
    sha256 = "1b06x4xxbr1dz5plw00b5r8pcz8rbc23w3nw1zhhng53ssyr8y6y";
  };

  cargoSha256 = "0j1wnvddbj1mfxzmfzw2fzcgs3di1zq8xy7ap7742dnhkhkczdhv";

  buildInputs = [
    ncurses
  ];

  meta = with stdenv.lib; {
    description = "Utility for selecting manpage section to be opened";
    homepage = "https://github.com/jtojnar/sman";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
