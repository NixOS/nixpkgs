{ stdenv, lib, fetchFromGitHub, rustPlatform, makeWrapper, ffmpeg
, pandoc, poppler_utils, ripgrep, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "ripgrep-all";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "phiresky";
    repo = pname;
    rev = version;
    sha256 = "1knv0gpanrid9i9mxg7zwqh9igdksp1623wl9iwmysiyaajlbif2";
  };

  cargoSha256 = "0xwsx0x9n766bxamhnpzibrnvnqsxz3wh1f0rj29kbl32xl8yyfg";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optional stdenv.isDarwin Security;

  postInstall = ''
    wrapProgram $out/bin/rga \
      --prefix PATH ":" "${lib.makeBinPath [ ffmpeg pandoc poppler_utils ripgrep ]}"
  '';

  meta = with stdenv.lib; {
    description = "Ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, and more";
    longDescription = ''
      Ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, etc.

      rga is a line-oriented search tool that allows you to look for a regex in
      a multitude of file types. rga wraps the awesome ripgrep and enables it
      to search in pdf, docx, sqlite, jpg, movie subtitles (mkv, mp4), etc.
    '';
    homepage = https://github.com/phiresky/ripgrep-all;
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ zaninime ];
    platforms = platforms.all;
  };
}
