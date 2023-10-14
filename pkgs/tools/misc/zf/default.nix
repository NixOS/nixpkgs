{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, testers
, zig_0_11
, callPackage
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zf";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "natecraddock";
    repo = "zf";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-qzGr72EnWlGZgd7/r+8Iv+1i/Q9qvWpf/cgkr+TrgkE=";
  };

  nativeBuildInputs = [
    installShellFiles
    zig_0_11.hook
  ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  postInstall = ''
    installManPage doc/zf.1
    installShellCompletion \
      --bash complete/zf \
      --fish complete/zf.fish \
      --zsh complete/_zf
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    homepage = "https://github.com/natecraddock/zf";
    description = "A commandline fuzzy finder that prioritizes matches on filenames";
    changelog = "https://github.com/natecraddock/zf/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dit7ya figsoda mmlb ];
  };
})
