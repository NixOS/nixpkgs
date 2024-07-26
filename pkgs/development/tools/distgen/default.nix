{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonApplication rec {
  pname = "distgen";
  version = "1.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Md6R1thUtPQ7BFZsWmTDuNdD7UHMMFlEVksIJZAyjk4=";
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
