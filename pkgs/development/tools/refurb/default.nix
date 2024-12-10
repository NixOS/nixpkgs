{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "refurb";
  version = "2.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dosisod";
    repo = "refurb";
    rev = "refs/tags/v${version}";
    hash = "sha256-6MchaqRKJPmvwiDyhCK4kFyIYl2B+2dGL8H8X2ES+VQ=";
  };

  postPatch = ''
    # remove --cov* options provided to pytest
    sed -i '/^addopts = "--cov/d' pyproject.toml
  '';

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    mypy
    mypy-extensions
    tomli
    typing-extensions
  ];

  nativeCheckInputs = with python3Packages; [
    attrs
    click
    colorama
    iniconfig
    mccabe
    packaging
    pathspec
    platformdirs
    pluggy
    py
    pyparsing
    pytestCheckHook
  ];

  disabledTests = [
    "test_checks" # broken because new mypy release added new checks
  ];

  pythonImportsCheck = [
    "refurb"
  ];

  meta = with lib; {
    description = "A tool for refurbishing and modernizing Python codebases";
    mainProgram = "refurb";
    homepage = "https://github.com/dosisod/refurb";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ knl ];
  };
}
