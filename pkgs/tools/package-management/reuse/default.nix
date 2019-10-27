{ lib, python3Packages, fetchFromGitHub }:

with python3Packages;

buildPythonApplication rec {
  pname = "reuse";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "fsfe";
    repo = "reuse-tool";
    rev = "v${version}";
    sha256 = "1w17g6jvs715rjc93nnnqnfdphijq4ymj9jjkr3ccc286ywvn3ih";
  };

  propagatedBuildInputs = [
    binaryornot
    boolean-py
    debian
    jinja2
    license-expression
    requests
    setuptools
  ];

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "A tool for compliance with the REUSE Initiative recommendations";
    homepage = "https://github.com/fsfe/reuse-tool";
    license = with licenses; [ asl20 cc-by-sa-40 cc0 gpl3 ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
