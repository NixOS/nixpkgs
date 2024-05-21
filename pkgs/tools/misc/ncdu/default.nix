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
  version = "2.4";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdu-${finalAttrs.version}.tar.gz";
    hash = "sha256-Sj0AAjCc9qfOp5GTjayb7N7OTVKdDW3I2RtztOaFVQk=";
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
