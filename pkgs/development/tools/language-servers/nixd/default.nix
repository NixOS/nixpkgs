{
  lib,
  stdenv,
  fetchFromGitHub,
  boost182,
  gtest,
  llvmPackages,
  meson,
  ninja,
  nix,
  nix-update-script,
  nixd,
  nixf,
  nixt,
  nlohmann_json,
  pkg-config,
  testers,
}:

let
  common = rec {
    version = "2.2.0";

    src = fetchFromGitHub {
      owner = "nix-community";
      repo = "nixd";
      rev = version;
      hash = "sha256-/8Ty1I130vWFidedt+WEaaFHS/zMFVu9vpq4Z3EBjGw=";
    };

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
    ];

    mesonBuildType = "release";

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

      buildInputs = [
        gtest
        boost182
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
        nix
        gtest
        boost182
      ];

      env.CXXFLAGS = "-include ${nix.dev}/include/nix/config.h";

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
        nix
        nixf
        nixt
        llvmPackages.llvm
        gtest
        boost182
      ];

      env.CXXFLAGS = "-include ${nix.dev}/include/nix/config.h";

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
