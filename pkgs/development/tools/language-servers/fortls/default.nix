{ buildPythonApplication
, lib
, fetchFromGitHub
, setuptools-scm
, json5
, packaging
}:

buildPythonApplication rec {
  pname = "fortls";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "fortran-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4iOE9OkqSu7enEMx4aAaGZ0KDKCT1377Su728JncIso=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ json5 packaging ];

  doCheck = true;
  checkPhase = "$out/bin/fortls --help 1>/dev/null";

  meta = with lib; {
    description = "Fortran Language Server ";
    mainProgram = "fortls";
    homepage = "https://github.com/fortran-lang/fortls";
    license = [ licenses.mit ];
    maintainers = [ maintainers.sheepforce ];
  };
}
