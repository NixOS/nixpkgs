{ lib
, stdenv
, fetchFromGitHub
, fetchzip
, SDL2
, SDL2_net
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "opentyrian";
  version = "2.1.20220318";

  src = fetchFromGitHub {
    owner = "opentyrian";
    repo = "opentyrian";
    rev = "v${version}";
    sha256 = "01z1zxpps4ils0bnwazl9lmqdbfhfd8fkacahnh6kqyczavg40xg";
  };

  data = fetchzip {
    url = "https://camanis.net/tyrian/tyrian21.zip";
    sha256 = "1biz6hf6s7qrwn8ky0g6p8w7yg715w7yklpn6258bkks1s15hpdb";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL2 SDL2_net ];

  enableParallelBuilding = true;

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = ''
    mkdir -p $out/share/games/tyrian
    cp -r $data/* $out/share/games/tyrian/
  '';

  meta = {
    description = ''Open source port of the game "Tyrian"'';
    homepage = "https://github.com/opentyrian/opentyrian";
    # This does not account of Tyrian data.
    # license = lib.licenses.gpl2;
  };
}
