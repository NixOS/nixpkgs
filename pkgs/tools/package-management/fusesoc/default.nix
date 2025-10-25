{
  buildPythonPackage,
  fetchPypi,
  lib,
  iverilog,
  verilator,
  gnumake,
  edalize,
  fastjsonschema,
  pyparsing,
  pyyaml,
  simplesat,
  ipyxact,
  setuptools-scm,
  argcomplete,
}:
buildPythonPackage rec {
  pname = "fusesoc";
  version = "2.4.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SE28RM4AK2kBQ58Ah+eWN+VZTgX856IAApgCgZNSLgM=";
  };

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

  makeWrapperArgs = [
    "--suffix PATH : ${
      lib.makeBinPath [
        iverilog
        verilator
        gnumake
      ]
    }"
  ];

  meta = with lib; {
    homepage = "https://github.com/olofk/fusesoc";
    description = "Package manager and build tools for HDL code";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
    mainProgram = "fusesoc";
  };
}
