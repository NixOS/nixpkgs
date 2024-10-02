{ lib
, crystal
, fetchFromGitHub
, llvmPackages
, openssl
, makeWrapper
}:

let
  version = "0.14.0";
in
crystal.buildCrystalPackage {
  pname = "crystalline";
  inherit version;

  src = fetchFromGitHub {
    owner = "elbywan";
    repo = "crystalline";
    rev = "v${version}";
    hash = "sha256-NTuI9sYprX6lu/nfHU4U9bEks6EHlXz/L4yQJ5j3XvA=";
  };

  format = "crystal";
  shardsFile = ./shards.nix;

  nativeBuildInputs = [ llvmPackages.llvm openssl makeWrapper ];

  doCheck = false;
  doInstallCheck = false;

  crystalBinaries.crystalline = {
    src = "src/crystalline.cr";
    options = [ "--release" "--no-debug" "--progress" "-Dpreview_mt" ];
  };

  postInstall = ''
    wrapProgram "$out/bin/crystalline" --prefix PATH : '${
      lib.makeBinPath [llvmPackages.llvm.dev]
    }'
  '';

  meta = with lib; {
    description = "Language Server Protocol implementation for Crystal";
    mainProgram = "crystalline";
    homepage = "https://github.com/elbywan/crystalline";
    license = licenses.mit;
    maintainers = with maintainers; [ donovanglover ];
  };
}
