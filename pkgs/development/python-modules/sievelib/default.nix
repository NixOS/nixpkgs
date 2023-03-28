{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sievelib";
  version = "1.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7cubQWqYWjzFt9f01+wBPjcuv5DmTJ2eAOIDEpmvOP0=";
  };

  nativeBuildInputs = [
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
    description = "Client-side Sieve and Managesieve library written in Python";
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
    license = licenses.mit;
    maintainers = with maintainers; [ leenaars ];
  };
}
