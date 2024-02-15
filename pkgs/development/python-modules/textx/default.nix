{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, mkdocs
, twine
, arpeggio
, click
, future
, setuptools
, callPackage
, gprof2dot
, html5lib
, jinja2
, psutil
, pytestCheckHook
}:

let
  textx = buildPythonPackage rec {
    pname = "textx";
    version = "3.0.0";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = version;
      hash = "sha256-uZlO82dKtWQQR5+Q7dWk3+ZoUzAjDJ8qzC4UMLCtnBk=";
    };

    postPatch = ''
      substituteInPlace setup.cfg --replace "click >=7.0, <8.0" "click >=7.0"
    '';

    outputs = [
      "out"
      "testout"
    ];

    nativeBuildInputs = [
      mkdocs
      twine
    ];

    propagatedBuildInputs = [
      arpeggio
      click
      future
      setuptools
    ];

    postInstall = ''
      # FileNotFoundError: [Errno 2] No such file or directory: '$out/lib/python3.10/site-packages/textx/textx.tx
      cp "$src/textx/textx.tx" "$out/${python.sitePackages}/${pname}/"

      # Install tests as the tests output.
      mkdir $testout
      cp -r tests $testout/tests
    '';

    pythonImportsCheck = [
      "textx"
    ];

    # Circular dependencies, do tests in passthru.tests instead.
    doCheck = false;

    passthru.tests = {
      textxTests = callPackage ./tests.nix {
        inherit
          textx-data-dsl
          textx-example-project
          textx-flow-codegen
          textx-flow-dsl
          textx-types-dsl;
       };
    };

    meta = with lib; {
      description = "Domain-specific languages and parsers in Python";
      homepage = "https://github.com/textx/textx/";
      license = licenses.mit;
      maintainers = with maintainers; [ yuu ];
    };
  };

  textx-data-dsl = buildPythonPackage rec {
    pname = "textx-data-dsl";
    version = "1.0.0";
    inherit (textx) src;
    # `format` isn't included in the output of `mk-python-derivation`.
    # So can't inherit format: `error: attribute 'format' missing`.
    format = "setuptools";
    pathToSourceRoot = "tests/functional/registration/projects/data_dsl";
    sourceRoot = "${src.name}/" + pathToSourceRoot;
    propagatedBuildInputs = [
      textx
      textx-types-dsl
    ];
    meta = with lib; {
      inherit (textx.meta) license maintainers;
      description = "Sample textX language for testing";
      homepage = textx.homepage + "tree/${version}/" + pathToSourceRoot;
    };
  };

  textx-flow-codegen = buildPythonPackage rec {
    pname = "textx-flow-codegen";
    version = "1.0.0";
    inherit (textx) src;
    format = "setuptools";
    pathToSourceRoot = "tests/functional/registration/projects/flow_codegen";
    sourceRoot = "${src.name}/" + pathToSourceRoot;
    propagatedBuildInputs = [
      click
      textx
    ];
    meta = with lib; {
      inherit (textx.meta) license maintainers;
      description = "Sample textX language for testing";
      homepage = textx.homepage + "tree/${version}/" + pathToSourceRoot;
    };
  };

  textx-flow-dsl = buildPythonPackage rec {
    pname = "textx-flow-dsl";
    version = "1.0.0";
    inherit (textx) src;
    format = "setuptools";
    pathToSourceRoot = "tests/functional/registration/projects/flow_dsl";
    sourceRoot = "${src.name}/" + pathToSourceRoot;
    propagatedBuildInputs = [
      textx
    ];
    meta = with lib; {
      inherit (textx.meta) license maintainers;
      description = "Sample textX language for testing";
      homepage = textx.homepage + "tree/${version}/" + pathToSourceRoot;
    };
  };

  textx-types-dsl = buildPythonPackage rec {
    pname = "textx-types-dsl";
    version = "1.0.0";
    inherit (textx) src;
    format = "setuptools";
    pathToSourceRoot = "tests/functional/registration/projects/types_dsl";
    sourceRoot = "${src.name}/" + pathToSourceRoot;
    propagatedBuildInputs = [
      textx
    ];
    meta = with lib; {
      inherit (textx.meta) license maintainers;
      description = "Sample textX language for testing";
      homepage = textx.homepage + "tree/${version}/" + pathToSourceRoot;
    };
  };

  textx-example-project = buildPythonPackage rec {
    pname = "textx-example-project";
    version = "1.0.0";
    inherit (textx) src;
    format = "setuptools";
    pathToSourceRoot = "tests/functional/subcommands/example_project";
    sourceRoot = "${src.name}/" + pathToSourceRoot;
    propagatedBuildInputs = [
      textx
    ];
    meta = with lib; {
      inherit (textx.meta) license maintainers;
      description = "Sample textX sub-command for testing";
      homepage = textx.homepage + "tree/${version}/" + pathToSourceRoot;
    };
  };
in
  textx
