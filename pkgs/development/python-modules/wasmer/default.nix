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
      version = "1.2.0";
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
    cargoHash = "sha256-HKbVss6jGFdnCgXV3UYf6RxtmQM3+tq3cHfOSKw5JnY=";
  };

  wasmer-compiler-cranelift = common {
    pname = "wasmer-compiler-cranelift";
    buildAndTestSubdir = "packages/compiler-cranelift";
    cargoHash = "sha256-BTBkoTluK7IVS+TpbQnMjn2Wvwhfxv1ev5PZWS/kW0w=";
  };

  wasmer-compiler-llvm = common {
    pname = "wasmer-compiler-llvm";
    buildAndTestSubdir = "packages/compiler-llvm";
    cargoHash = "sha256-AfLp4RLfnJ3R1Wg+RCJRmYr7748LQtl1W+ttTgIMls4=";
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
    cargoHash = "sha256-4DoeKRjS/2ijpUva0p/AE3qoIyt8CvCjkPWFPyLH6gs=";
  };
}
