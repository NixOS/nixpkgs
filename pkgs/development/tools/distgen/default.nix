{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "distgen";
  version = "1.5";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "08f9rw5irgv0gw7jizk5f9csn0yhrdnb84k40px1zbypsylvr5c5";
  };

  nativeCheckInputs = with python3.pkgs; [
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
