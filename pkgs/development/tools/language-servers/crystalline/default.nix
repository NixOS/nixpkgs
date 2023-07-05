{ lib
, crystal
, fetchFromGitHub
, llvmPackages
, openssl
, makeWrapper
}:

let
  version = "0.9.0";
in
crystal.buildCrystalPackage {
  pname = "crystalline";
  inherit version;

  src = fetchFromGitHub {
    owner = "elbywan";
    repo = "crystalline";
    rev = "v${version}";
    sha256 = "sha256-kx3rdGqIbrOaHY7V3uXLqIFEYzzsMKzNwZ6Neq8zM3c=";
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
    description = "A Language Server Protocol implementation for Crystal";
    homepage = "https://github.com/elbywan/crystalline";
    license = licenses.mit;
    maintainers = with maintainers; [ donovanglover ];
  };
}
