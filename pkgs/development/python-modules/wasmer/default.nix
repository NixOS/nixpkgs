{ stdenv
, lib
, rustPlatform
, callPackage
, fetchFromGitHub
, buildPythonPackage
, libiconv
, libffi
, libxml2
, ncurses
, zlib
}:

let
  common =
    { pname
    , buildAndTestSubdir
    , cargoHash
    , extraNativeBuildInputs ? [ ]
    , extraBuildInputs ? [ ]
    }: buildPythonPackage rec {
      inherit pname;
      version = "1.1.0";
      format = "pyproject";

      outputs = [ "out" ] ++ lib.optional (pname == "wasmer") "testsout";

      src = fetchFromGitHub {
        owner = "wasmerio";
        repo = "wasmer-python";
        rev = version;
        hash = "sha256-nOeOhQ1XY+9qmLGURrI5xbgBUgWe5XRpV38f73kKX2s=";
      };

      cargoDeps = rustPlatform.fetchCargoTarball {
        inherit src;
        name = "${pname}-${version}";
        sha256 = cargoHash;
      };

      nativeBuildInputs = (with rustPlatform; [ cargoSetupHook maturinBuildHook ])
        ++ extraNativeBuildInputs;

      postPatch = ''
        # Workaround for metadata, that maturin 0.14 does not accept in Cargo.toml anymore
        substituteInPlace ${buildAndTestSubdir}/Cargo.toml \
          --replace "package.metadata.maturin" "broken"
      '';

      buildInputs = lib.optionals stdenv.isDarwin [ libiconv ]
        ++ extraBuildInputs;

      inherit buildAndTestSubdir;

      postInstall = lib.optionalString (pname == "wasmer") ''
        mkdir $testsout
        cp -R tests $testsout/tests
      '';

      # check in passthru.tests.pytest because all packages are required to run the tests
      doCheck = false;

      passthru.tests = lib.optionalAttrs (pname == "wasmer") {
        pytest = callPackage ./tests.nix { };
      };

      pythonImportsCheck = [ "${lib.replaceStrings ["-"] ["_"] pname}" ];

      meta = with lib; {
        broken = stdenv.isDarwin;
        description = "Python extension to run WebAssembly binaries";
        homepage = "https://github.com/wasmerio/wasmer-python";
        license = licenses.mit;
        platforms = platforms.unix;
        maintainers = with maintainers; [ SuperSandro2000 ];
      };
    };
in
rec {
  wasmer = common {
    pname = "wasmer";
    buildAndTestSubdir = "packages/api";
    cargoHash = "sha256-twoog8LjQtoli+TlDipSuB7yLFkXQJha9BqobqgZW3Y=";
  };

  wasmer-compiler-cranelift = common {
    pname = "wasmer-compiler-cranelift";
    buildAndTestSubdir = "packages/compiler-cranelift";
    cargoHash = "sha256-IqeMOY6emhIC7ekH8kIOZCr3JVkjxUg/lQli+ZZpdq4=";
  };

  wasmer-compiler-llvm = common {
    pname = "wasmer-compiler-llvm";
    buildAndTestSubdir = "packages/compiler-llvm";
    cargoHash = "sha256-xawbf5gXXV+7I2F2fDSaMvjtFvGDBtqX7wL3c28TSbA=";
    extraNativeBuildInputs = [ rustPlatform.rust.rustc.llvm ];
    extraBuildInputs = [ libffi libxml2.out ncurses zlib ];
  };

  wasmer-compiler-singlepass = common {
    pname = "wasmer-compiler-singlepass";
    buildAndTestSubdir = "packages/compiler-singlepass";
    cargoHash = "sha256-4nZHMCNumNhdGPOmHXlJ5POYP7K+VPjwhEUMgzGb/Rk=";
  };
}
