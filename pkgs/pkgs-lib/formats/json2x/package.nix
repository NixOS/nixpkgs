{
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "json2x";
  version = "0.1.0";
  __structuredAttrs = true;

  src = lib.sourceByRegex ./. [
    "^src(/.*)?$"
    ''^Cargo\.(lock|toml)$''
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
  };
}
