{ lib, stdenv, fetchFromGitLab, gitUpdater, asciidoctor }:

stdenv.mkDerivation (finalAttrs: {
  pname = "ascii";
  version = "3.20";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "ascii";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-vkU5QZdUfr8aGKlAK+4d4rL+lKD/7C7E1Ul1LPgfZXo=";
  };

  nativeBuildInputs = [
    asciidoctor
  ];

  prePatch = ''
    sed -i -e "s|^PREFIX = .*|PREFIX = $out|" Makefile
  '';

  preInstall = ''
    mkdir -vp "$out/bin" "$out/share/man/man1"
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Interactive ASCII name and synonym chart";
    mainProgram = "ascii";
    homepage = "http://www.catb.org/~esr/ascii/";
    changelog = "https://gitlab.com/esr/ascii/-/blob/${finalAttrs.version}/NEWS.adoc";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
})
