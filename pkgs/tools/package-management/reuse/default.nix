{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "reuse";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "fsfe";
    repo = "reuse-tool";
    rev = "v${version}";
    sha256 = "sha256-AkOwsfTPVsOl+X0Eo1ErqWWyMBxUhnOpVwbYvJfGLTY=";
  };

  propagatedBuildInputs = with python3Packages; [
    binaryornot
    boolean-py
    debian
    jinja2
    license-expression
    requests
    setuptools
    setuptools-scm
  ];

  checkInputs = with python3Packages; [ pytestCheckHook ];

  meta = with lib; {
    description = "A tool for compliance with the REUSE Initiative recommendations";
    homepage = "https://github.com/fsfe/reuse-tool";
    license = with licenses; [
      gpl3Plus # All original source code
      asl20 # Some borrowed source code
      cc-by-sa-40 # Documentation
      cc0 # Some configuration and data files
    ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
