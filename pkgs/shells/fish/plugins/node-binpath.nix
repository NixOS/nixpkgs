{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildFishPlugin rec {
  pname = "node-binpath";
  version = "0-unstable-2023-08-23";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-${pname}";
    rev = "70ecbe7be606b1b26bfd1a11e074bc92fe65550c";
    hash = "sha256-Hkm9dhTC9lf2sviTIEBa56nayHgNVg8NOIvYg6EslH0=";
  };

  meta = {
    inherit (src.meta) homepage;
    description = "Automatically add node_modules binaries to PATH";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dudeofawesome ];
  };

  passthru = {
    updateScript = unstableGitUpdater { };
  };
}
