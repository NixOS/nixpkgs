{ buildPythonApplication
, lib
, fetchFromGitHub
, setuptools-scm
, json5
, packaging
}:

buildPythonApplication rec {
  pname = "fortls";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "fortran-lang";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kFk2Dlnb0FXM3Ysvsy+g2AAMgpWmwzxuyJPovDm/FJU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ json5 packaging ];

  doCheck = true;
  checkPhase = "$out/bin/fortls --help 1>/dev/null";

  meta = with lib; {
    description = "Fortran Language Server ";
    homepage = "https://github.com/fortran-lang/fortls";
    license = [ licenses.mit ];
    maintainers = [ maintainers.sheepforce ];
  };
}
