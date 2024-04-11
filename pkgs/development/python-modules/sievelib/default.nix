{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sievelib";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MxPX8fP4Mkq2qOISnknXbuCN8NQ+L1UOaBuPEuP0TNE=";
  };

  build-system = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sievelib"
  ];

  meta = with lib; {
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
    license = licenses.mit;
    maintainers = with maintainers; [ leenaars ];
  };
}
