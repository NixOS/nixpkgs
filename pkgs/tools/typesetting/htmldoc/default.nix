{ lib, stdenv, testers, fetchFromGitHub, zlib, cups, libpng, libjpeg, SystemConfiguration, Foundation, pkg-config, htmldoc }:

stdenv.mkDerivation rec {
  pname = "htmldoc";
  version = "1.9.18";
  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "htmldoc";
    rev = "v${version}";
    sha256 = "sha256-fibk58X0YtQ8vh8Lyqp9ZAsC79BjCptiqUA5t5Hiisg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib cups libpng libjpeg ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Foundation SystemConfiguration ];

  # do not generate universal binary on Darwin
  # because it is not supported by Nix's clang
  postPatch = ''
    substituteInPlace configure --replace "-arch x86_64 -arch arm64" ""
  '';

  passthru.tests = testers.testVersion {
    package = htmldoc;
    command = "htmldoc --version";
  };

  meta = with lib; {
    description = "Converts HTML files to PostScript and PDF";
    homepage    = "https://michaelrsweet.github.io/htmldoc";
    changelog   = "https://github.com/michaelrsweet/htmldoc/releases/tag/v${version}";
    license     = licenses.gpl2Only;
    maintainers = [ ];
    platforms   = platforms.unix;

    longDescription = ''
      HTMLDOC is a program that reads HTML source files or web pages and
      generates corresponding HTML, PostScript, or PDF files with an optional
      table of contents.
    '';
    mainProgram = "htmldoc";
  };
}
