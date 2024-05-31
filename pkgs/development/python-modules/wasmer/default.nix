{
  stdenv,
  lib,
  rustPlatform,
  callPackage,
  fetchFromGitHub,
  buildPythonPackage,
  pythonAtLeast,
  libiconv,
  libffi,
  libxml2,
  llvm_14,
  ncurses,
  zlib,
}:

let
  common =
    {
      pname,
      buildAndTestSubdir,
      cargoHash,
      extraNativeBuildInputs ? [ ],
      extraBuildInputs ? [ ],
    }:
    buildPythonPackage rec {
      inherit pname;
      version = "1.1.1";
      format = "pyproject";

      outputs = [ "out" ] ++ lib.optional (pname == "wasmer") "testsout";

      src = fetchFromGitHub {
        owner = "wasmerio";
        repo = "wasmer-python";
        rev = version;
        hash = "sha256-Iu28LMDNmtL2r7gJV5Vbb8HZj18dlkHe+mw/Y1L8YKE=";
      };

      cargoDeps = rustPlatform.fetchCargoTarball {
        inherit src;
        name = "${pname}-${version}";
        sha256 = cargoHash;
      };

      nativeBuildInputs =
        (with rustPlatform; [
          cargoSetupHook
          maturinBuildHook
        ])
        ++ extraNativeBuildInputs;

      postPatch = ''
        # Workaround for metadata, that maturin 0.14 does not accept in Cargo.toml anymore
        substituteInPlace ${buildAndTestSubdir}/Cargo.toml \
          --replace "package.metadata.maturin" "broken"
      '';

      buildInputs = lib.optionals stdenv.isDarwin [ libiconv ] ++ extraBuildInputs;

      inherit buildAndTestSubdir;

      postInstall = lib.optionalString (pname == "wasmer") ''
        mkdir $testsout
        cp -R tests $testsout/tests
      '';

      # check in passthru.tests.pytest because all packages are required to run the tests
      doCheck = false;

      passthru.tests = lib.optionalAttrs (pname == "wasmer") { pytest = callPackage ./tests.nix { }; };

      pythonImportsCheck = [ "${lib.replaceStrings [ "-" ] [ "_" ] pname}" ];

      meta = with lib; {
        # https://github.com/wasmerio/wasmer-python/issues/778
        broken = pythonAtLeast "3.12";
        description = "Python extension to run WebAssembly binaries";
        homepage = "https://github.com/wasmerio/wasmer-python";
        license = licenses.mit;
        platforms = platforms.unix;
        maintainers = [ ];
      };
    };
in
{
  wasmer = common {
    pname = "wasmer";
    buildAndTestSubdir = "packages/api";
    cargoHash = "sha256-vpbwU1HrIQmQkce9SK8UOHrX5tOLv/XKsfJHteqOteA=";
  };

  wasmer-compiler-cranelift = common {
    pname = "wasmer-compiler-cranelift";
    buildAndTestSubdir = "packages/compiler-cranelift";
    cargoHash = "sha256-nv4cr52mUIuR3LWRT3eXU5b2LORwuN4iMbLX1efzovI=";
  };

  wasmer-compiler-llvm = common {
    pname = "wasmer-compiler-llvm";
    buildAndTestSubdir = "packages/compiler-llvm";
    cargoHash = "sha256-FA/xXlPaK8NxZIw7MCm9Fyesgu72Dsxhmb5xzOIINhE=";
    extraNativeBuildInputs = [ llvm_14 ];
    extraBuildInputs = [
      libffi
      libxml2.out
      ncurses
      zlib
    ];
  };

  wasmer-compiler-singlepass = common {
    pname = "wasmer-compiler-singlepass";
    buildAndTestSubdir = "packages/compiler-singlepass";
    cargoHash = "sha256-yew7cB/7RLjW55jZmHFfIvaErgZ6XVxL1ucGGX2Cx18=";
  };
}
