{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "ucsmsdk";
  version = "0.9.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CiscoUcs";
    repo = "ucsmsdk";
    tag = "v${version}";
    hash = "sha256-hpGWaBlzfb5rcmgnmVQFGGH5T/EJRdilIH4Q83Ml8XQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyparsing
    six
  ];

  # most tests are broken
  doCheck = false;

  pythonImportsCheck = [ "ucsmsdk" ];

  meta = {
    description = "Python SDK for Cisco UCS";
    homepage = "https://github.com/CiscoUcs/ucsmsdk";
    changelog = "https://github.com/CiscoUcs/ucsmsdk/blob/${src.tag}/HISTORY.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
