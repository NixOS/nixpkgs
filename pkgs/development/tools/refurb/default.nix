{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "refurb";
  version = "1.12.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dosisod";
    repo = "refurb";
    rev = "refs/tags/v${version}";
    hash = "sha256-dS9+S3RogsBlbEHyq5Ll3kGbULwIQHQkwwNjjbsrgio=";
  };

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

  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml
  '';

  pythonImportsCheck = [
    "refurb"
  ];

  meta = with lib; {
    description = "A tool for refurbishing and modernizing Python codebases";
    homepage = "https://github.com/dosisod/refurb";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ knl ];
  };
}
