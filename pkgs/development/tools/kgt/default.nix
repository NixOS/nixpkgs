{ lib, stdenv, fetchFromGitHub, bmake, cleanPackaging }:

stdenv.mkDerivation {
  pname = "kgt";
  version = "2021-04-07";

  src = fetchFromGitHub {
    owner = "katef";
    repo = "kgt";
    # 2021-04-07, no version tags (yet)
    rev = "a7cbc52d368e413a3f1212c0fafccc05b2a42606";
    sha256 = "1x6q30xb8ihxi26rzk3s2hqd827fim4l4wn3qq252ibrwcq6lqyj";
    fetchSubmodules = true;
  };

  outputs = [ "bin" "doc" "out" ];

  nativeBuildInputs = [ bmake ];
  enableParallelBuilding = true;

  makeFlags = [ "-r" "PREFIX=$(bin)" ];

  installPhase = ''
    runHook preInstall

    ${cleanPackaging.commonFileActions {
        docFiles = [
          "README.md"
          "LICENCE"
          "examples"
          # TODO: this is just a docbook file, not a mangpage yet
          # https://github.com/katef/kgt/issues/50
          "man"
          "examples"
          "doc"
        ];
        noiseFiles = [
          "build/src"
          "build/lib"
          "Makefile"
          "src/**/*.c"
          "src/**/*.h"
          "src/**/Makefile"
          "src/**/lexer.lx"
          "src/**/parser.sid"
          "src/**/parser.act"
          "share/git"
          "share/css"
          "share/xsl"
          ".gitignore"
          ".gitmodules"
          ".gitattributes"
          ".github"
        ];
      }} $doc/share/doc/kgt

    install -Dm755 build/bin/kgt $bin/bin/kgt
    rm build/bin/kgt

    runHook postInstall
  '';

  postFixup = ''
    ${cleanPackaging.checkForRemainingFiles}
  '';

  meta = with lib; {
    description = "BNF wrangling and railroad diagrams";
    longDescription = ''
      KGT: Kate's Grammar Tool

      Input: Various BNF-like syntaxes
      Output: Various BNF-like syntaxes, AST dumps, and Railroad Syntax Diagrams
    '';
    homepage    = "https://github.com/katef/kgt";
    license     = licenses.bsd2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ Profpatsch ];
  };

}
