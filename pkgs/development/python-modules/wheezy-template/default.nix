{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wheezy.template";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4RAHysczaNzhKZjjS2bEdgFrtGFHH/weTVboQALslg8=";
  };

  pythonImportsCheck = [ "wheezy.template" ];

  meta = with lib; {
    homepage = "https://wheezytemplate.readthedocs.io/en/latest/";
    description = "A lightweight template library";
    license = licenses.mit;
    maintainers = with maintainers; [ lilyinstarlight ];
  };
}
