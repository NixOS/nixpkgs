{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  gtest,
  llvmPackages,
  meson,
  mesonEmulatorHook,
  ninja,
  nixVersions,
  nix-update-script,
  nixd,
  nixf,
  nixt,
  nlohmann_json,
  pkg-config,
  testers,
  python3,
  libxml2,
  zlib,
}:

let
  nixComponents = nixVersions.nixComponents_2_34;
  common = rec {
    version = "2.9.2";

    src = fetchFromGitHub {
      owner = "nix-community";
      repo = "nixd";
      tag = version;
      hash = "sha256-rjLF0nTRuPKVyxXjNlkHG6k4SdcSwjNOW26u/qlP8uA=";
    };

    nativeBuildInputs = [
      meson
      ninja
      python3
      pkg-config
      llvmPackages.llvm # workaround for a meson bug, where llvm-config is not found, making the build fail
    ];

    mesonBuildType = "release";

    strictDeps = true;

    doCheck = true;

    meta = {
      homepage = "https://github.com/nix-community/nixd";
      changelog = "https://github.com/nix-community/nixd/releases/tag/${version}";
      license = lib.licenses.lgpl3Plus;
      maintainers = with lib.maintainers; [
        inclyc
        Ruixi-rebirth
        aleksana
      ];
      platforms = lib.platforms.unix;
    };
  };
in
{
  nixf = stdenv.mkDerivation (
    common
    // {
      pname = "nixf";

      sourceRoot = "${common.src.name}/libnixf";

      outputs = [
        "out"
        "dev"
      ];

      nativeBuildInputs =
        common.nativeBuildInputs
        ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [ mesonEmulatorHook ];

      buildInputs = [
        nixComponents.nix-expr
        gtest
        boost
        nlohmann_json
      ];

      passthru.tests.pkg-config = testers.hasPkgConfigModules {
        package = nixf;
        moduleNames = [ "nixf" ];
      };

      meta = common.meta // {
        description = "Nix language frontend, parser & semantic analysis";
        mainProgram = "nixf-tidy";
      };
    }
  );

  nixt = stdenv.mkDerivation (
    common
    // {
      pname = "nixt";

      sourceRoot = "${common.src.name}/libnixt";

      outputs = [
        "out"
        "dev"
      ];

      buildInputs = [
        nixComponents.nix-main
        nixComponents.nix-expr
        nixComponents.nix-cmd
        nixComponents.nix-flake
        gtest
        boost
      ];

      passthru.tests.pkg-config = testers.hasPkgConfigModules {
        package = nixt;
        moduleNames = [ "nixt" ];
      };

      meta = common.meta // {
        description = "Supporting library that wraps C++ nix";
      };
    }
  );

  nixd = stdenv.mkDerivation (
    common
    // {
      pname = "nixd";

      sourceRoot = "${common.src.name}/nixd";

      buildInputs = [
        nixComponents.nix-main
        nixComponents.nix-expr
        nixComponents.nix-cmd
        nixComponents.nix-flake
        nixf
        nixt
        llvmPackages.llvm
        gtest
        boost
        libxml2
        zlib
      ];

      nativeBuildInputs = common.nativeBuildInputs ++ [ cmake ];

      mesonFlags = [ (lib.mesonBool "llvm_static" true) ];

      disallowedRequisites = [ (lib.getLib llvmPackages.llvm) ];

      # See https://github.com/nix-community/nixd/issues/519
      doCheck = false;

      passthru = {
        updateScript = nix-update-script { };
        tests.version = testers.testVersion { package = nixd; };
      };

      meta = common.meta // {
        description = "Feature-rich Nix language server interoperating with C++ nix";
        mainProgram = "nixd";
      };
    }
  );
}
