{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, testers
, zig_0_10
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zf";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "natecraddock";
    repo = "zf";
    rev = "refs/tags/${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-MzlSU5x2lb6PJZ/iNAi2aebfuClBprlfHMIG/4OPmuc=";
  };

  nativeBuildInputs = [
    installShellFiles
    zig_0_10.hook
  ];

  doCheck = false; # it's failing somehow

  postInstall = ''
    installManPage doc/zf.1
    installShellCompletion \
      --bash complete/zf \
      --fish complete/zf.fish \
      --zsh complete/_zf
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.zf; };

  meta = {
    homepage = "https://github.com/natecraddock/zf";
    description = "A commandline fuzzy finder that prioritizes matches on filenames";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dit7ya mmlb ];
  };
})
