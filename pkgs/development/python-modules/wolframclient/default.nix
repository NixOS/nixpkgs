{ lib
, buildPythonPackage
, fetchPypi
, pyzmq
, numpy
, pytz
, requests
, aiohttp
, oauthlib
}:

buildPythonPackage rec {
  pname = "wolframclient";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vhgmr9i6qa98qv8sn7ph35m2gayjyif6d2q0sjbfdgihsh0ly8f";
  };

  propagatedBuildInputs = [
    pyzmq
    numpy
    pytz
    requests
    aiohttp
    oauthlib
  ];

  # see https://github.com/WolframResearch/WolframClientForPython/issues/18
  doCheck = false;
  pythonImportsCheck = [
    "wolframclient"
    "wolframclient.cli"
    "wolframclient.evaluation"
    "wolframclient.language"
  ];

  meta = with lib; {
    homepage = "https://reference.wolfram.com/language/WolframClientForPython/index.html";
    description = "Call Wolfram Language functions from Python";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
