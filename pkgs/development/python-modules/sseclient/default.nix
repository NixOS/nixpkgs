<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, requests
, six
}:
=======
{ lib, buildPythonPackage, fetchPypi, isPy27
, requests, six
, backports_unittest-mock, pytestCheckHook, pytest-runner }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "sseclient";
  version = "0.0.27";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sv5TTcszsdP6rRPWDFp8cY4o+FmH8qA07PXsJ5kYwRw=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "event_stream"
  ];
=======

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2fe534dcb33b1d3faad13d60c5a7c718e28f85987f2a034ecf5ec279918c11c";
  };

  propagatedBuildInputs = [ requests six ];

  # some tests use python3 strings
  doCheck = !isPy27;
  nativeCheckInputs = [ backports_unittest-mock pytestCheckHook pytest-runner ];

  # tries to open connection to wikipedia
  disabledTests = [ "event_stream" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Client library for reading Server Sent Event streams";
    homepage = "https://github.com/btubbs/sseclient";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
