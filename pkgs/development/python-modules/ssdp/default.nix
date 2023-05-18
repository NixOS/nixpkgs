{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, flit-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ssdp";
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-D2mww3sEc2SvufWNmT450a2CW+ogROn3RHypljkebuY=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov" ""
  '';

  nativeBuildInputs = [
    flit-core
    flit-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ssdp"
  ];

  meta = with lib; {
    description = "Python asyncio library for Simple Service Discovery Protocol (SSDP)";
    homepage = "https://github.com/codingjoe/ssdp";
    changelog = "https://github.com/codingjoe/ssdp/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
