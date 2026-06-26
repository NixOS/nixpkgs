{
  lib,
  crystal,
  fetchFromGitHub,
  llvmPackages,
  openssl,
  makeWrapper,
}:

let
  version = "0.17.1";
  src = fetchFromGitHub {
    owner = "elbywan";
    repo = "crystalline";
    tag = "v${version}";
    hash = "sha256-SIfInDY6KhEwEPZckgobOrpKXBDDd0KhQt/IjdGBhWo=";
  };
in
crystal.buildCrystalPackage {
  pname = "crystalline";
  inherit version src;

  format = "crystal";
  shardsFile = ./shards.nix;

  nativeBuildInputs = [
    llvmPackages.llvm
    openssl
    makeWrapper
  ];
  env.LLVM_CONFIG = lib.getExe' (lib.getDev llvmPackages.llvm) "llvm-config";

  preConfigure = ''
    substituteInPlace "./src/crystalline/main.cr" \
      --replace-fail '`shards version #{__DIR__}`' '"${version}"' \
      --replace-fail 'system("git rev-parse --short HEAD || echo unknown").stringify' '"${src.rev}"'
  '';

  doCheck = false;
  doInstallCheck = false;

  crystalBinaries.crystalline = {
    src = "src/crystalline.cr";
    options = [
      "--release"
      "--no-debug"
      "--progress"
      "-Dpreview_mt"
    ];
  };

  postInstall = ''
    wrapProgram "$out/bin/crystalline" --prefix PATH : '${
      lib.makeBinPath [
        (lib.getDev llvmPackages.llvm)
      ]
    }'
  '';

  meta = {
    description = "Language Server Protocol implementation for Crystal";
    mainProgram = "crystalline";
    homepage = "https://github.com/elbywan/crystalline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donovanglover ];
  };
}
