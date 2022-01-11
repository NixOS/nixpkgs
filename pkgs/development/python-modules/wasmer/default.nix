{ stdenv
, lib
, rustPlatform
, callPackage
, fetchFromGitHub
, buildPythonPackage
, libiconv
, llvm_11
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
      version = "1.0.0";
      format = "pyproject";

      outputs = [ "out" ] ++ lib.optional (pname == "wasmer") "testsout";

      src = fetchFromGitHub {
        owner = "wasmerio";
        repo = "wasmer-python";
        rev = version;
        hash = "sha256-I1GfjLaPYMIHKh2m/5IQepUsJNiVUEJg49wyuuzUYtY=";
      };

      cargoDeps = rustPlatform.fetchCargoTarball {
        inherit src;
        name = "${pname}-${version}";
        sha256 = cargoHash;
      };

      nativeBuildInputs = (with rustPlatform; [ cargoSetupHook maturinBuildHook ])
        ++ extraNativeBuildInputs;

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
    cargoHash = "sha256-txOOia1C4W+nsXuXp4EytEn82CFfSmiOYwRLC4WPImc=";
  };

  wasmer-compiler-cranelift = common {
    pname = "wasmer-compiler-cranelift";
    buildAndTestSubdir = "packages/compiler-cranelift";
    cargoHash = "sha256-cHgAUwqnbQV3E5nUYGYQ48ntbIFfq4JXfU5IrSFZ3zI=";
  };

  wasmer-compiler-llvm = common {
    pname = "wasmer-compiler-llvm";
    buildAndTestSubdir = "packages/compiler-llvm";
    cargoHash = "sha256-Jm22CC5S3pN/vdVvsGZdvtoAgPzWVLto8wavSJdxY3A=";
    extraNativeBuildInputs = [ llvm_11 ];
    extraBuildInputs = [ libffi libxml2.out ncurses zlib ];
  };

  wasmer-compiler-singlepass = common {
    pname = "wasmer-compiler-singlepass";
    buildAndTestSubdir = "packages/compiler-singlepass";
    cargoHash = "sha256-lmqEo3+jYoN+4EEYphcoE4b84jdFcvYVycjrJ956Bh8=";
  };
}
