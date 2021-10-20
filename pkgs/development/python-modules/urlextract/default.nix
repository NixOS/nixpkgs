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
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "669f07192584b841b49ba8868fbd6b00e7ddc28367d36a3d8ca8c8e429420748";
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
