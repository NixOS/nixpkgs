{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "sievelib";
<<<<<<< HEAD
  version = "1.4.3";
=======
  version = "1.4.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-bFemWvAc6WbJCxPlLxT7+acDd2egcbg4FHTMWrIxBPQ=";
=======
    hash = "sha256-YOoANqVRTiYQ5b9WFYbzJOdf/ZGnIJ9fueBrj+KLBrs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools-scm ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sievelib" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
