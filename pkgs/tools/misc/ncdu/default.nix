{ lib
, stdenv
, fetchurl
, ncurses
, zig
, installShellFiles
, testers
, pie ? stdenv.isDarwin
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncdu";
  version = "2.5";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdu-${finalAttrs.version}.tar.gz";
    hash = "sha256-f0neJQJKurGvH/IrO4VCwNFY4Bj+DpYHT9lLDh5tMaU=";
  };

  nativeBuildInputs = [
    zig.hook
    installShellFiles
  ];

  buildInputs = [
    ncurses
  ];

  zigBuildFlags = lib.optional pie "-Dpie=true";

  postInstall = ''
    installManPage ncdu.1
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    homepage = "https://dev.yorhel.nl/ncdu";
    description = "Disk usage analyzer with an ncurses interface";
    changelog = "https://dev.yorhel.nl/ncdu/changes2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pSub rodrgz ];
    inherit (zig.meta) platforms;
    mainProgram = "ncdu";
  };
})
