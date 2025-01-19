{
  buildPythonApplication,
  lib,
  fetchFromGitHub,
  setuptools-scm,
  json5,
  packaging,
}:

buildPythonApplication rec {
  pname = "fortls";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "fortran-lang";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-mOYPtysPj+JczRPTeM1DUckAH0XC9cO1ssP8pviYa0E=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    json5
    packaging
  ];

  doCheck = true;
  checkPhase = "$out/bin/fortls --help 1>/dev/null";

  meta = {
    description = "Fortran Language Server";
    mainProgram = "fortls";
    homepage = "https://github.com/fortran-lang/fortls";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.sheepforce ];
  };
}
