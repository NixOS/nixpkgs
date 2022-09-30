{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, idna
, multidict
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yarl";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-r4h4RbjC4GDrVgX/crby3SqrenYTeTc/2J0xT0dSq78=";
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
