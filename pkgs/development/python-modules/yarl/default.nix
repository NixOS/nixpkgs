{ lib
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
, idna
, multidict
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yarl";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e7ebaf62e19c2feb097ffb7c94deb0f0c9fab52590784c8cd679d30ab009162";
  };

  postPatch = ''
    sed -i '/^addopts/d' setup.cfg
  '';

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

  checkInputs = [
    pytestCheckHook
  ];

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [ "yarl" ];

  meta = with lib; {
    description = "Yet another URL library";
    homepage = "https://github.com/aio-libs/yarl";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
