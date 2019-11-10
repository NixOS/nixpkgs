{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "distgen";
  version = "1.4";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "13k940xgpci754gmmnhz3j5rfvlg9hdh21j4yjh8dlr6g88qjc1x";
  };

  checkInputs = with python3.pkgs; [
    pytest
    mock
  ];

  propagatedBuildInputs = with python3.pkgs; [
    distro
    jinja2
    six
    pyyaml
  ];

  checkPhase = "make test-unit PYTHON=${python3.executable}";

  meta = with lib; {
    description = "Templating system/generator for distributions";
    license = licenses.gpl2Plus;
    homepage = "https://distgen.readthedocs.io/";
    maintainers = with maintainers; [ bachp ];
  };
}
