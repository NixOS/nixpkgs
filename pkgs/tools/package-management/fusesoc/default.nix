{
  buildPythonPackage,
  fetchPypi,
  lib,
  edalize,
  fastjsonschema,
  pyparsing,
  pyyaml,
  simplesat,
  ipyxact,
  argcomplete,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "fusesoc";
  version = "2.4.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/CWwbLUvUWzQDG0EyfY4IF5G8+NehA/D+OwAuzpkBdU=";
  };

  patches = [ ./fusesoc-without-jsonschema2md.patch ];

  pyproject = true;
  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    edalize
    fastjsonschema
    pyparsing
    pyyaml
    simplesat
    ipyxact
    argcomplete
  ];

  pythonImportsCheck = [ "fusesoc" ];

  meta = with lib; {
    homepage = "https://github.com/olofk/fusesoc";
    description = "Package manager and build tools for HDL code";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
    mainProgram = "fusesoc";
  };
}
