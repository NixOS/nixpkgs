{
  lib,
  buildPythonPackage,
  dnspython,
  fetchPypi,
  filelock,
  idna,
  platformdirs,
  pytestCheckHook,
  setuptools,
  uritools,
}:

buildPythonPackage rec {
  pname = "urlextract";
  version = "1.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VckUA+CfTh99NroO+4iIPkdu8UyNQjvdzgmDlckL4dg=";
  };

  nativeBuildInputs = [ setuptools ];

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

  pythonImportsCheck = [ "urlextract" ];

  meta = {
    description = "Collects and extracts URLs from given text";
    mainProgram = "urlextract";
    homepage = "https://github.com/lipoja/URLExtract";
    changelog = "https://github.com/lipoja/URLExtract/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilkecan ];
  };
}
