{ stdenv, lib, runCommand, patchelf, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "fuelup";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "FuelLabs";
    repo = "fuelup";
    rev = "v${version}";
    sha256 = "sha256-scvBallzXumYQqzyP8U5yd68pd33IleEFJaGt6YTJVQ=";
  };

  cargoSha256 = "sha256-bd3FHpB453oYgpu3mkh5CU1h1zcll+wm6VnJ8NO2XzM=";

  nativeBuildInputs = [ ];

  buildInputs = [ ];

  buildFeatures = [ ];

  checkFeatures = [ ];

  patches = lib.optionals stdenv.isLinux [
    (runCommand "0001-dynamically-patchelf-binaries.patch" {
      CC = stdenv.cc;
      patchelf = patchelf;
    } ''
      export dynamicLinker=$(cat $CC/nix-support/dynamic-linker)
      substitute ${./0001-dynamically-patchelf-binaries.patch} $out \
        --subst-var patchelf \
        --subst-var dynamicLinker
    '')
  ];

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  postInstall = ''
    pushd $out/bin
    binlinks=(
      forc forc-explore forc-lsp fuel-core forc-deploy
      forc-fmt forc-run fuel-indexer forc-doc forc-index
      forc-wallet
    )
    for link in ''${binlinks[@]}; do
      ln -s fuelup $link
    done
    popd
  '';

  preCheck = ''
    # some tests need a valid home
    export HOME=$(mktemp -d)
  '';

  checkFlags = [
    # some tests use the network, disable them
    "--skip=fuelup_check"
    "--skip=fuelup_component_add"
    "--skip=fuelup_component_add_with_version"
    "--skip=fuelup_self_update"
  ];

  meta = with lib; {
    description = "The Fuel toolchain manager";
    homepage = "https://fuellabs.github.io/fuelup/latest";
    license = licenses.asl20;
    maintainers = [ maintainers.IGI-111 ];
  };

}
