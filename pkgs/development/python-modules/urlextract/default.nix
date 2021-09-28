{ lib
, appdirs
, buildPythonPackage
, dnspython
, fetchPypi
, filelock
, idna
, pytestCheckHook
, uritools
}:

buildPythonPackage rec {
  pname = "urlextract";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yxOuiswFOJnAvxwTT++Zhk8nZWK2f4ePsQpUYI7EYS4=";
  };

  propagatedBuildInputs = [
    appdirs
    filelock
    idna
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

  pythonImportsCheck = [ "urlextract" ];

  meta = with lib; {
    description = "Collects and extracts URLs from given text";
    homepage = "https://github.com/lipoja/URLExtract";
    license = licenses.mit;
    maintainers = with maintainers; [ ilkecan ];
  };
}
