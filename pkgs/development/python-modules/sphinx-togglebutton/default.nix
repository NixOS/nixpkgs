{ lib
, buildPythonPackage
, fetchPypi
, wheel
, sphinx
, docutils
}:

buildPythonPackage rec {
  pname = "sphinx-togglebutton";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f13c25c27a8ff40d6fc924d324746c0adb0dedeef40730c8a8b64ff55c6c92c";
  };

  propagatedBuildInputs = [ wheel sphinx docutils ];

  pythonImportsCheck = [ "sphinx_togglebutton" ];

  meta = with lib; {
    description = "Toggle page content and collapse admonitions in Sphinx";
    homepage = "https://github.com/executablebooks/sphinx-togglebutton";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
