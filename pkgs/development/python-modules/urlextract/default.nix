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
  version = "1.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NXP2uBKBTv4GykbpHoLZhO2qPNB9qqqilqRnrZiBoDc=";
  };

  propagatedBuildInputs = [
    filelock
    idna
    platformdirs
    uritools
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/lipoja/URLExtract/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ilkecan ];
  };
}
