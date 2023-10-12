{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "reuse";
  version = "2.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fsfe";
    repo = "reuse-tool";
    rev = "refs/tags/v${version}";
    hash = "sha256-MEQiuBxe/ctHlAnmLhQY4QH62uAcHb7CGfZz+iZCRSk=";
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    binaryornot
    boolean-py
    debian
    jinja2
    license-expression
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  disabledTestPaths = [
    # pytest wants to execute the actual source files for some reason, which fails with ImportPathMismatchError()
    "src/reuse"
  ];

  meta = with lib; {
    description = "A tool for compliance with the REUSE Initiative recommendations";
    homepage = "https://github.com/fsfe/reuse-tool";
    license = with licenses; [ asl20 cc-by-sa-40 cc0 gpl3Plus ];
    maintainers = with maintainers; [ FlorianFranzen Luflosi ];
  };
}
