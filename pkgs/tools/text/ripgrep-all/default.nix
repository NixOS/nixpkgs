{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, makeWrapper
, ffmpeg
, pandoc
, poppler_utils
, ripgrep
, Security
, zip
}:

rustPlatform.buildRustPackage rec {
  pname = "ripgrep-all";
  version = "1.0.0-alpha.5";

  src = fetchFromGitHub {
    owner = "phiresky";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fpDYzn4oAz6GJQef520+Vi2xI09xFjpWdAlFIAVzcoA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tokio-tar-0.3.1" = "sha256-gp4UM6YV7P9k1FZxt3eVjyC4cK1zvpMjM5CPt2oVBEA=";
    };
  };

  nativeBuildInputs = [ makeWrapper poppler_utils ];
  buildInputs = lib.optional stdenv.isDarwin Security;

  postInstall = ''
    wrapProgram $out/bin/rga \
    --prefix PATH ":" "${lib.makeBinPath [ ffmpeg pandoc poppler_utils ripgrep zip ]}"
  '';

  meta = with lib; {
    description = "Ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, and more";
    longDescription = ''
      Ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, etc.

      rga is a line-oriented search tool that allows you to look for a regex in
      a multitude of file types. rga wraps the awesome ripgrep and enables it
      to search in pdf, docx, sqlite, jpg, movie subtitles (mkv, mp4), etc.
    '';
    homepage = "https://github.com/phiresky/ripgrep-all";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ zaninime ma27 ];
    mainProgram = "rga";
  };
}
