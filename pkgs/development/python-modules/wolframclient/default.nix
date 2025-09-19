{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  oauthlib,
  pyzmq,
}:

buildPythonPackage rec {
  pname = "wolframclient";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WfHwpxJX+nnERMyUiQl/504seJAVfyUqlhzqQG4X6fs=";
  };

  propagatedBuildInputs = [
    oauthlib
    pyzmq
  ];
  pythonImportsCheck = [ "wolframclient" ];

  meta = with lib; {
    maintainers = with maintainers; [ undefined-moe ];
    description = "A Python library with various tools to interact with the Wolfram Language and the Wolfram Cloud.";
    homepage = "https://reference.wolfram.com/language/WolframClientForPython/";
    license = with licenses; [ mit ];
  };
}
