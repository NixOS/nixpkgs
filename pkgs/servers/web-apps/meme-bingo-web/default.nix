{ lib
, fetchFromGitea
, rustPlatform
, makeWrapper
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "meme-bingo-web";
  version = "1.0.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "meme-bingo-web";
    rev = "v${version}";
    hash = "sha256-mOcN9WIXJYRK23tMX29mT5/eSRpqb++zlnJnMizzIfY=";
  };

  cargoHash = "sha256-JWVsmw8ha2TSkCXyLPf9Qe1eL2OHB5uu+bSfCaF0lV8=";

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
