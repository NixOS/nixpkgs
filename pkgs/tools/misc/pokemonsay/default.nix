{ lib
, stdenvNoCC
, fetchFromGitHub
, cowsay
, coreutils
, findutils
}:

stdenvNoCC.mkDerivation rec {
  pname = "pokemonsay";
  version = "unstable-2021-10-05";

  src = fetchFromGitHub {
    owner = "HRKings";
    repo = "pokemonsay-newgenerations";
    rev = "baccc6d2fe1897c48f60d82ff9c4d4c018f5b594";
    hash = "sha256-IDTAZmOzkUg0kLUM0oWuVbi8EwE4sEpLWrNAtq/he+g=";
  };

  postPatch = ''
    substituteInPlace pokemonsay.sh \
      --replace \
        'INSTALL_PATH=''${HOME}/.bin/pokemonsay' \
        "" \
      --replace \
        'POKEMON_PATH=''${INSTALL_PATH}/pokemons' \
        'POKEMON_PATH=${placeholder "out"}/share/pokemonsay' \
      --replace \
        '$(find ' \
        '$(${findutils}/bin/find ' \
      --replace \
        '$(basename ' \
        '$(${coreutils}/bin/basename ' \
      --replace \
        'cowsay -f ' \
        '${cowsay}/bin/cowsay -f ' \
      --replace \
        'cowthink -f ' \
        '${cowsay}/bin/cowthink -f '

    substituteInPlace pokemonthink.sh \
      --replace \
        './pokemonsay.sh' \
        "${placeholder "out"}/bin/pokemonsay"
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/pokemonsay}
    cp pokemonsay.sh $out/bin/pokemonsay
    cp pokemonthink.sh $out/bin/pokemonthink
    cp pokemons/*.cow $out/share/pokemonsay
  '';

  checkPhase = ''
    $out/bin/pokemonsay --list-pokemon
  '';

  meta = with lib; {
    description = "Print pokemon in the CLI! An adaptation of the classic cowsay";
    homepage = "https://github.com/HRKings/pokemonsay-newgenerations";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pbsds ];
  };
}
