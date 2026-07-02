{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  compressed-rtf,

  pytestCheckHook,
  pytest-console-scripts,
}:

buildPythonPackage rec {
  pname = "tnefparse";
  version = "1.4.0";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "koodaamo";
    repo = "tnefparse";
    tag = version;
    hash = "sha256-t2ouuuy6fzwb6SZNpxeGSleL/11SgTT8Ce28/ST1glw=";
  };

  optional-dependencies = {
    compressed-rtf = [ compressed-rtf ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-console-scripts

    # tests always require this.
    compressed-rtf
  ];

  disabledTests = [
    # ensures there's a "optional argument" in the CLI usage, and its output has changed since.
    "test_help_is_printed"
  ];

  pythonImportsCheck = [ "tnefparse" ];

  meta = {
    description = "TNEF decoding library written in python, without external dependencies";
    homepage = "https://github.com/koodaamo/tnefparse";
    changelog = "https://github.com/koodaamo/tnefparse/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      flokli
    ];
  };
}
