{
  lib,
  buildPythonPackage,
  python,
  fetchFromGitHub,
  arpeggio,
  click,
  callPackage,
  flit-core,
}:

let
  textx = buildPythonPackage rec {
    pname = "textx";
    version = "4.2.3";
    pyproject = true;

    src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = version;
      hash = "sha256-2ZRu7aDDiq+EUjqYI7CxzsmPNXGmWc7DI4ocVZbj3gM=";
    };

    outputs = [
      "out"
      "testout"
    ];

    build-system = [ flit-core ];

    dependencies = [ arpeggio ];

    postInstall = ''
      # FileNotFoundError: [Errno 2] No such file or directory: '$out/lib/python3.10/site-packages/textx/textx.tx
      cp "$src/textx/textx.tx" "$out/${python.sitePackages}/${pname}/"

      # Install tests as the tests output.
      mkdir $testout
      cp -r tests $testout/tests
    '';

    pythonImportsCheck = [ "textx" ];

    # Circular dependencies, do tests in passthru.tests instead.
    doCheck = false;

    passthru.tests = {
      textxTests = callPackage ./tests.nix {
        inherit
          textx-data-dsl
          textx-example-project
          textx-flow-codegen
          textx-flow-dsl
          textx-types-dsl
          ;
      };
    };

    meta = with lib; {
      description = "Domain-specific languages and parsers in Python";
      mainProgram = "textx";
      homepage = "https://github.com/textx/textx/";
      license = licenses.mit;
      maintainers = [ ];
    };
  };

  textx-data-dsl = buildPythonPackage rec {
    pname = "textx-data-dsl";
    version = "1.0.0";
    pyproject = true;

    inherit (textx) src;
    pathToSourceRoot = "tests/functional/registration/projects/data_dsl";
    sourceRoot = "${src.name}/" + pathToSourceRoot;

    build-system = [ flit-core ];

    dependencies = [
      textx
      textx-types-dsl
    ];

    meta = {
      inherit (textx.meta) license maintainers;
      description = "Sample textX language for testing";
      homepage = textx.meta.homepage + "tree/${version}/" + pathToSourceRoot;
    };
  };

  textx-flow-codegen = buildPythonPackage rec {
    pname = "textx-flow-codegen";
    version = "1.0.0";
    pyproject = true;

    inherit (textx) src;

    pathToSourceRoot = "tests/functional/registration/projects/flow_codegen";
    sourceRoot = "${src.name}/" + pathToSourceRoot;

    build-system = [ flit-core ];
    dependencies = [
      textx
      click
    ];

    meta = {
      inherit (textx.meta) license maintainers;
      description = "Sample textX language for testing";
      homepage = textx.meta.homepage + "tree/${version}/" + pathToSourceRoot;
    };
  };

  textx-flow-dsl = buildPythonPackage rec {
    pname = "textx-flow-dsl";
    version = "1.0.0";
    pyproject = true;

    inherit (textx) src;

    pathToSourceRoot = "tests/functional/registration/projects/flow_dsl";
    sourceRoot = "${src.name}/" + pathToSourceRoot;

    build-system = [ flit-core ];
    dependencies = [ textx ];

    meta = {
      inherit (textx.meta) license maintainers;
      description = "Sample textX language for testing";
      homepage = textx.meta.homepage + "tree/${version}/" + pathToSourceRoot;
    };
  };

  textx-types-dsl = buildPythonPackage rec {
    pname = "textx-types-dsl";
    version = "1.0.0";
    pyproject = true;

    inherit (textx) src;

    pathToSourceRoot = "tests/functional/registration/projects/types_dsl";
    sourceRoot = "${src.name}/" + pathToSourceRoot;

    build-system = [ flit-core ];
    dependencies = [ textx ];

    meta = {
      inherit (textx.meta) license maintainers;
      description = "Sample textX language for testing";
      homepage = textx.meta.homepage + "tree/${version}/" + pathToSourceRoot;
    };
  };

  textx-example-project = buildPythonPackage rec {
    pname = "textx-example-project";
    version = "1.0.0";
    pyproject = true;

    inherit (textx) src;

    pathToSourceRoot = "tests/functional/subcommands/example_project";
    sourceRoot = "${src.name}/" + pathToSourceRoot;

    build-system = [ flit-core ];
    dependencies = [ textx ];

    meta = {
      inherit (textx.meta) license maintainers;
      description = "Sample textX sub-command for testing";
      homepage = textx.meta.homepage + "tree/${version}/" + pathToSourceRoot;
    };
  };
in
textx
