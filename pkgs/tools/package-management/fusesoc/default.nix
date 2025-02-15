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
}:
buildPythonPackage rec {
  pname = "fusesoc";
  version = "2.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ruYx9dDAm23jV4tw1Op+6Pe1ea1c7VWH5RzqasFsZ6E=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    edalize
    fastjsonschema
    pyparsing
    pyyaml
    simplesat
    ipyxact
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
