{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cython_3
, expandvars
, setuptools
, idna
, multidict
, typing-extensions
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yarl";
  version = "1.9.4";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Vm24ZxfPgIC5m1iwg7dzqQiuQPBmgeh+WJqXb6+CRr8=";
  };

  postPatch = ''
    sed -i '/cov/d' pytest.ini
  '';

  nativeBuildInputs = [
    cython_3
    expandvars
    setuptools
  ];

  propagatedBuildInputs = [
    idna
    multidict
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  preCheck = ''
    # don't import yarl from ./ so the C extension is available
    pushd tests
  '';

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [ "yarl" ];

  meta = with lib; {
    changelog = "https://github.com/aio-libs/yarl/blob/v${version}/CHANGES.rst";
    description = "Yet another URL library";
    homepage = "https://github.com/aio-libs/yarl";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
