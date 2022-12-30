{ lib
, buildPythonPackage
, fetchFromGitHub
, pbr
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "ssdp";
  version = "1.1.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-D2mww3sEc2SvufWNmT450a2CW+ogROn3RHypljkebuY=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pbr
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" "" \
      --replace "--cov=ssdp" ""
  '';

  pythonImportsCheck = [ "ssdp" ];

  meta = with lib; {
    description = "Python asyncio library for Simple Service Discovery Protocol (SSDP)";
    homepage = "https://github.com/codingjoe/ssdp";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
