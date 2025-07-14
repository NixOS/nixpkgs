{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytz,
  requests,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "taxii2-client";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "oasis-open";
    repo = "cti-taxii-client";
    tag = "v${version}";
    hash = "sha256-e22bJdLAlm30vv/xIgLSjcwmzfN0Pwt2JydLgEbA+Is=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pytz
    requests
    six
  ];

  pythonImportsCheck = [ "taxii2client" ];

  meta = {
    description = "TAXII 2 client library";
    homepage = "https://github.com/oasis-open/cti-taxii-client/";
    changelog = "https://github.com/oasis-open/cti-taxii-client/blob/${src.rev}/CHANGES.txt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
