{ lib
, fetchFromGitea
, rustPlatform
, makeWrapper
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "meme-bingo-web";
  version = "1.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "meme-bingo-web";
    rev = "v${version}";
    hash = "sha256-AKY0EjeoOnliRN3XSnlCgzCvnWOkZPQz/9QIcr8+hQM=";
  };

  cargoHash = "sha256-/+9fxIk3EQxG3PzQLRsYcwBHDZaOtWUsAYGa7t1jLHY=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/share/meme-bingo-web
    cp -r {templates,static} $out/share/meme-bingo-web/

    wrapProgram $out/bin/meme-bingo-web \
      --set MEME_BINGO_TEMPLATES $out/share/meme-bingo-web/templates \
      --set MEME_BINGO_STATIC $out/share/meme-bingo-web/static
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Play meme bingo using this neat web app";
    mainProgram = "meme-bingo-web";
    homepage = "https://codeberg.org/annaaurora/meme-bingo-web";
    license = licenses.unlicense;
    maintainers = with maintainers; [ annaaurora ];
  };
}
