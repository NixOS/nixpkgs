{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "distgen";
  version = "1.3";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "03jwy08wgp1lp6208vks1hv9g1f3aj45cml6k99mm3nw1jfnlbbq";
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
