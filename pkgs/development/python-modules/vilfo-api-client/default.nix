{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  getmac,
  requests,
  semver,
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "vilfo-api-client";
  version = "0.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ManneW";
    repo = "vilfo-api-client-python";
    tag = version;
    hash = "sha256-ZlmriBd+M+54ux/UNYa355mkz808/NxSz7IzmWouA0c=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "get-mac" "getmac"
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    getmac
    requests
    semver
  ];

  nativeCheckInputs = [
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
