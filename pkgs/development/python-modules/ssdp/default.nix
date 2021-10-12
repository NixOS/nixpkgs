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
  version = "1.1.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = pname;
    rev = version;
    sha256 = "19d2b5frpq2qkfkpz173wpjk5jwhkjpk75p8q92nm8iv41nrzljy";
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
