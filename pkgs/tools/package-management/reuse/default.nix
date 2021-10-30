{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "reuse";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "fsfe";
    repo = "reuse-tool";
    rev = "v${version}";
    sha256 = "0didqsbvrn06aylp71jl3hqb4rd95d8s613xz6jw6mngyjqv0hq2";
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
    license = with licenses; [ asl20 cc-by-sa-40 cc0 gpl3Plus ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
