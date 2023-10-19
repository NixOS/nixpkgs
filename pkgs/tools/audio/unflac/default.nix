{ lib
, buildGoModule
, fetchFromSourcehut
, ffmpeg
, makeWrapper
}:

buildGoModule rec {
  pname = "unflac";
  version = "1.1";

  src = fetchFromSourcehut {
    owner = "~ft";
    repo = pname;
    rev = version;
    sha256 = "sha256-gDgmEEOvsudSYdLUodTuE50+2hZpMqlnaVGanv/rg+U=";
  };

  vendorHash = "sha256-X3cMhzaf1t+x7D8BVBfQy00rAACDEPmIOezIhKzqOZ8=";

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
  };
}
