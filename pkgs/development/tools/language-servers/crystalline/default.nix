{
  lib,
  crystal,
  fetchFromGitHub,
  llvmPackages,
  openssl,
  shards,
  makeWrapper,
  _experimental-update-script-combinators,
  crystal2nix,
  runCommand,
  writeShellScript,
  gitUpdater,
  testers,
  crystalline,
}:

let
  version = "0.17.1";
in
crystal.buildCrystalPackage rec {
  pname = "crystalline";
  inherit version;

  src = fetchFromGitHub {
    owner = "elbywan";
    repo = "crystalline";
    rev = "v${version}";
    hash = "sha256-SIfInDY6KhEwEPZckgobOrpKXBDDd0KhQt/IjdGBhWo=";
  };

  format = "crystal";
  shardsFile = ./shards.nix;

  nativeBuildInputs = [
    llvmPackages.llvm
    openssl
    makeWrapper
    shards
  ];

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
    wrapProgram "$out/bin/crystalline" --prefix PATH : '${lib.makeBinPath [ llvmPackages.llvm.dev ]}'
  '';

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "crystalline.shardLock" "${builtins.toString ./.}/shard.lock")
      {
        command = [
          (writeShellScript "update-lock" "cd $1; ${lib.getExe crystal2nix}")
          ./.
        ];
        supportedFeatures = [ "silent" ];
      }
      {
        command = [
          "rm"
          "${builtins.toString ./.}/shard.lock"
        ];
        supportedFeatures = [ "silent" ];
      }
    ];
    shardLock = runCommand "shard.lock" { inherit src; } ''
      cp $src/shard.lock $out
    '';

    # Since doInstallCheck causes another test error, versionCheckHook is avoided.
    tests.version = testers.testVersion {
      package = crystalline;
    };
  };

  meta = {
    description = "Language Server Protocol implementation for Crystal";
    mainProgram = "crystalline";
    homepage = "https://github.com/elbywan/crystalline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donovanglover ];
  };
}
