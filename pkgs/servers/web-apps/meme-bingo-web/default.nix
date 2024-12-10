{
  lib,
  fetchFromGitea,
  rustPlatform,
  makeWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "meme-bingo-web";
  version = "0.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "meme-bingo-web";
    rev = "v${version}";
    hash = "sha256-6hQra+10TaaQGzwiYfL+WHmGc6f0Hn8Tybd0lA5t0qc=";
  };

  cargoHash = "sha256-/hBymxNAzyfapUL5Whkg4NBLA7Fc8A1npXEa9MXTAz4=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/share/meme-bingo-web
    cp -r {templates,static} $out/share/meme-bingo-web/

    wrapProgram $out/bin/meme-bingo-web \
      --set MEME_BINGO_TEMPLATES $out/share/meme-bingo-web/templates \
      --set MEME_BINGO_STATIC $out/share/meme-bingo-web/static
  '';

  meta = with lib; {
    description = "Play meme bingo using this neat web app";
    mainProgram = "meme-bingo-web";
    homepage = "https://codeberg.org/annaaurora/meme-bingo-web";
    license = licenses.unlicense;
    maintainers = with maintainers; [ annaaurora ];
  };
}
