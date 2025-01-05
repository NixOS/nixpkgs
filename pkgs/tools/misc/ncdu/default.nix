{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  pkg-config,
  zig,
  zstd,
  installShellFiles,
  testers,
  pie ? stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncdu";
  version = "2.7";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdu-${finalAttrs.version}.tar.gz";
    hash = "sha256-shjMFKK7mFLPlR204hrsiYDnqMOsoJfjqjQX8g65MAA=";
  };

  nativeBuildInputs = [
    zig.hook
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    ncurses
    zstd
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
    maintainers = with lib.maintainers; [
      pSub
      rodrgz
    ];
    inherit (zig.meta) platforms;
    mainProgram = "ncdu";
  };
})
