
{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  unstableGitUpdater
}:
rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2024-07-15";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "63549df4406216cce7e744576b1ee8fcaba9a30a";
    hash = "sha256-Y7LvsCuirhYPjuQSF0w7me8vYrV39i4OhVvyI3XskpE=";
  };

  buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.IOKit;

  cargoHash = "sha256-bBHIepmrp8E7FGizlYdu2Crv8W2CKqUdD+YJowWCRgc=";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Nushell formatter";
    homepage = "https://github.com/nushell/nufmt";
    license = lib.licenses.mit;
    maintainers = [lib.maintainers.iogamaster];
  };
}
