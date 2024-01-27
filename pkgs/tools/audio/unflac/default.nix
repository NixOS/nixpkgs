{ lib
, buildGoModule
, fetchFromSourcehut
, ffmpeg
, makeWrapper
}:

buildGoModule rec {
  pname = "unflac";
  version = "1.2";

  src = fetchFromSourcehut {
    owner = "~ft";
    repo = pname;
    rev = version;
    sha256 = "sha256-BgXuPAXrw28axfTEh10Yh8dQc27M1/lSmCo2eAeNnjE=";
  };

  vendorHash = "sha256-IQHxEYv6l8ORoX+a3Szox9tS2fyBk0tpK+Q1AsWohX0=";

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/unflac --prefix PATH : "${lib.makeBinPath [ffmpeg]}"
  '';

  meta = with lib; {
    description =
      "A command line tool for fast frame accurate audio image + cue sheet splitting";
    homepage = "https://sr.ht/~ft/unflac/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ felipeqq2 ];
    mainProgram = "unflac";
  };
}
