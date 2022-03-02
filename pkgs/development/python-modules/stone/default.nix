{ lib, buildPythonPackage, fetchPypi
, coverage
, mock
, ply
, pytest-runner
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "stone";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TvA5dRL2CXV5dffsCbNWOdcrp+PhfOTd85lXg0a0y1A=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner == 5.2.0" "pytest-runner" \
      --replace "pytest < 5" "pytest"
    substituteInPlace test/requirements.txt \
      --replace "coverage==5.3" "coverage"
  '';

  nativeBuildInputs = [ pytest-runner ];

  propagatedBuildInputs = [ ply six ];

  checkInputs = [ pytestCheckHook coverage mock ];

  # try to import from `test` directory, which is exported by the python interpreter
  # and cannot be overriden without removing some py3 to py2 support
  disabledTestPaths = [
    "test/test_tsd_types.py"
    "test/test_js_client.py"
  ];
  disabledTests = [
    "test_type_name_with_module"
  ];

  pythonImportsCheck = [ "stone" ];

  meta = with lib; {
    description = "Official Api Spec Language for Dropbox";
    homepage = "https://github.com/dropbox/stone";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
