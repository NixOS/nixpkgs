{ lib
, buildPythonPackage
, dnspython
, fetchPypi
, filelock
, idna
, platformdirs
, pytestCheckHook
, pythonOlder
, uritools
}:

buildPythonPackage rec {
  pname = "urlextract";
  version = "1.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DYg7Wd5Th4c+o4JeYrNDWDMTE1rGZMP1wNVfF7Kzv30=";
  };

  propagatedBuildInputs = [
    filelock
    idna
    platformdirs
    uritools
  ];

  checkInputs = [
    dnspython
    pytestCheckHook
  ];

  disabledTests = [
    # fails with dns.resolver.NoResolverConfiguration due to network sandboxing
    "test_check_dns_enabled"
    "test_check_dns_find_urls"
    "test_dns_cache_init"
    "test_dns_cache_negative"
    "test_dns_cache_reuse"
  ];

  pythonImportsCheck = [
    "urlextract"
  ];

  meta = with lib; {
    description = "Collects and extracts URLs from given text";
    homepage = "https://github.com/lipoja/URLExtract";
    license = licenses.mit;
    maintainers = with maintainers; [ ilkecan ];
  };
}
