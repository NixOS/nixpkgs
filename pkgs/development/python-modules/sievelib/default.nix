{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pytestCheckHook,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "sievelib";
  version = "1.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VcEa0/QEqsX/D07J4K41Th2AOu1yxEUkWY0l3qyGsLg=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sievelib" ];

  meta = {
    description = "Client-side Sieve and Managesieve library";
    longDescription = ''
      A library written in Python that implements RFC 5228 (Sieve: An Email
      Filtering Language) and RFC 5804 (ManageSieve: A Protocol for
      Remotely Managing Sieve Scripts), as well as the following extensions:

       * Copying Without Side Effects (RFC 3894)
       * Body (RFC 5173)
       * Date and Index (RFC 5260)
       * Vacation (RFC 5230)
       * Imap4flags (RFC 5232)
    '';
    homepage = "https://github.com/tonioo/sievelib";
    changelog = "https://github.com/tonioo/sievelib/releases/tag/${version}";
    license = lib.licenses.mit;
  };
}
