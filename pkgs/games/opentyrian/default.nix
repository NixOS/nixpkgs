{ lib, stdenv, fetchurl, fetchzip, SDL, SDL_net }:

stdenv.mkDerivation rec {
  pname = "opentyrian";
  version = "2.1.20130907";

  src = fetchurl {
    url = "https://bitbucket.org/opentyrian/opentyrian/get/${version}.tar.gz";
    sha256 = "1jnrkq616pc4dhlbd4n30d65vmn25q84w6jfv9383l9q20cqf2ph";
  };

  data = fetchzip {
    url = "http://sites.google.com/a/camanis.net/opentyrian/tyrian/tyrian21.zip";
    sha256 = "1biz6hf6s7qrwn8ky0g6p8w7yg715w7yklpn6258bkks1s15hpdb";
  };

  buildInputs = [SDL SDL_net];

  patchPhase = "
    substituteInPlace src/file.c --replace /usr/share $out/share
  ";
  buildPhase = "make release";
  installPhase = "
    mkdir -p $out/bin
    cp ./opentyrian $out/bin
    mkdir -p $out/share/opentyrian/data
    cp -r $data/* $out/share/opentyrian/data
  ";

  meta = {
    description = ''Open source port of the game "Tyrian"'';
    homepage = "https://bitbucket.org/opentyrian/opentyrian";
    # This does not account of Tyrian data.
    # license = lib.licenses.gpl2;
  };
}
