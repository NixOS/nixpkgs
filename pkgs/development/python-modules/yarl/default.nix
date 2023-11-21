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
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yarl";
  version = "1.9.3";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ShSQe1l+xVdA9j5S1/7g6e4J1bnVek85mnQjJo5Fe1c=";
  };

  postPatch = ''
    sed -i '/^addopts/d' setup.cfg
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
