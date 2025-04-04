{
  lib,
  suffix ? "",
  version,
  src,
  patches ? [ ],
  maintainers ? lib.teams.lix.members,
}@args:

{
  stdenv,
  lib,
  lix,
  boost,
  nlohmann_json,
  meson,
  pkg-config,
  ninja,
  cmake,
  buildPackages,
}:

stdenv.mkDerivation {
  pname = "nix-eval-jobs";
  version = "${version}${suffix}";
  inherit src patches;
  buildInputs = [
    nlohmann_json
    lix
    boost
  ];
  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    # nlohmann_json can be only discovered via cmake files
    cmake
  ] ++ (lib.optional stdenv.cc.isClang [ buildPackages.clang-tools ]);

  # point 'nix edit' and ofborg at the file that defines the attribute,
  # not this common file.
  pos = builtins.unsafeGetAttrPos "version" args;
  meta = {
    description = "Hydra's builtin `hydra-eval-jobs` as a standalone tool";
    mainProgram = "nix-eval-jobs";
    homepage =
      # Starting with 2.93, `nix-eval-jobs` lives in the `lix` repository.
      if lib.versionAtLeast version "2.93" then
        "https://git.lix.systems/lix-project/lix/src/branch/main/subprojects/nix-eval-jobs"
      else
        "https://git.lix.systems/lix-project/nix-eval-jobs";
    license = lib.licenses.gpl3;
    inherit maintainers;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isStatic;
  };
}
