{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, getmac
, requests
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "vilfo-api-client";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "ManneW";
    repo = "vilfo-api-client-python";
    rev = "v${version}";
    sha256 = "1gy5gpsg99rcm1cc3m30232za00r9i46sp74zpd12p3vzz1wyyqf";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "get-mac" "getmac"
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    getmac
    requests
  ];

  checkInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "vilfo" ];

  meta = with lib; {
    description = "Simple wrapper client for the Vilfo router API";
    homepage = "https://github.com/ManneW/vilfo-api-client-python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
