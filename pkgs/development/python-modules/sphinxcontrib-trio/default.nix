{ lib
, buildPythonPackage
, fetchPypi
, python3
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-trio";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nxupwdWWW1NOhSWNi2d92U6bGpoukYuFzNQlkFlrR8A=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    sphinx
  ];

  pythonImportsCheck = [ "sphinxcontrib_trio" ];

  meta = with lib; {
    description = "Make Sphinx better at documenting Python functions and methods";
    homepage = "https://pypi.org/project/sphinxcontrib-trio/";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ laggron42 ];
  };
}
