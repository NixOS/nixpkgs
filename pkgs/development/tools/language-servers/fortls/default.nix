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
  version = "3.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fortran-lang";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-cUZBr+dtTFbd68z6ts4quIPp9XYMikUBrCq+icrZ1KU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    json5
    packaging
  ];

  doCheck = true;
  checkPhase = "$out/bin/fortls --help 1>/dev/null";

  meta = with lib; {
    description = "Fortran Language Server";
    mainProgram = "fortls";
    homepage = "https://github.com/fortran-lang/fortls";
    license = [ licenses.mit ];
    maintainers = [ maintainers.sheepforce ];
  };
}
