{ lib
, stdenvNoCC
, fetchFromGitHub
, fetchpatch
, cowsay
, coreutils
, findutils
}:

stdenvNoCC.mkDerivation rec {
  pname = "pokemonsay";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "HRKings";
    repo = "pokemonsay-newgenerations";
    rev = "v${version}";
    hash = "sha256-IDTAZmOzkUg0kLUM0oWuVbi8EwE4sEpLWrNAtq/he+g=";
  };

  patches = [
    (fetchpatch { # https://github.com/HRKings/pokemonsay-newgenerations/pull/5
      name = "word-wrap-fix.patch";
      url = "https://github.com/pbsds/pokemonsay-newgenerations/commit/7056d7ba689479a8e6c14ec000be1dfcd83afeb0.patch";
      hash = "sha256-aqUJkyJDWArLjChxLZ4BbC6XAB53LAqARzTvEAxrFCI=";
    })
  ];

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

  doInstallCheck = true;
  installCheckPhase = ''
    (set -x
      test "$($out/bin/pokemonsay --list | wc -l)" -ge 891
    )
  '';

  meta = with lib; {
    description = "Print pokemon in the CLI! An adaptation of the classic cowsay";
    homepage = "https://github.com/HRKings/pokemonsay-newgenerations";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pbsds ];
  };
}
