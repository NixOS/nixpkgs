{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  webencodings,
  pytestCheckHook,
  flit-core,
}:

buildPythonPackage rec {
  pname = "tinyhtml5";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CG+ZiDPaJMMAxBTZ/oHZs2j9BMudJZagCEIcvHBfz8w=";
  };

  build-system = [ flit-core ];
  dependencies = [ webencodings ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "HTML parser based on the WHATWG HTML specification";
    homepage = "https://github.com/CourtBouillon/tinyhtml5";
    license = licenses.mit;
    maintainers = with maintainers; [ phaer ];
  };
}
