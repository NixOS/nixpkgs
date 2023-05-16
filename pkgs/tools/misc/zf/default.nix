<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, testers
, zig_0_10
}:

stdenv.mkDerivation (finalAttrs: {
=======
{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  testers,
  zf,
}:
stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "zf";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "natecraddock";
<<<<<<< HEAD
    repo = "zf";
    rev = "refs/tags/${finalAttrs.version}";
=======
    repo = pname;
    rev = "refs/tags/${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
    hash = "sha256-MzlSU5x2lb6PJZ/iNAi2aebfuClBprlfHMIG/4OPmuc=";
  };

<<<<<<< HEAD
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
=======
  nativeBuildInputs = [ zig ];

  dontConfigure = true;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dcpu=baseline --prefix $out install
    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {package = zf;};

  meta = with lib; {
    homepage = "https://github.com/natecraddock/zf";
    description = "A commandline fuzzy finder that prioritizes matches on filenames";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dit7ya mmlb ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
