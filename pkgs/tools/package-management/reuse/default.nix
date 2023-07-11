{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "reuse";
  version = "1.1.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fsfe";
    repo = "reuse-tool";
    rev = "refs/tags/v${version}";
    hash = "sha256-J+zQrokrAX5tRU/2RPPSaFDyfsACPHHQYbK5sO99CMs=";
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
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  meta = with lib; {
    description = "A tool for compliance with the REUSE Initiative recommendations";
    homepage = "https://github.com/fsfe/reuse-tool";
    license = with licenses; [ asl20 cc-by-sa-40 cc0 gpl3Plus ];
    maintainers = with maintainers; [ FlorianFranzen Luflosi ];
  };
}
