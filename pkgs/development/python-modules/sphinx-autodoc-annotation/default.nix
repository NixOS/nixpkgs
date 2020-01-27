{ lib, buildPythonPackage, fetchPypi, sphinx }:

buildPythonPackage rec {
  pname = "sphinx-autodoc-annotation";
  version = "1.0-1";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "4a3d03081efe1e5f2bc9b9d00746550f45b9f543b0c79519c523168ca7f7d89a";
  };
  
  propagatedBuildInputs = [ sphinx ];
  
  meta = with lib; {
    description = "Use Python 3 annotations in sphinx-enabled docstrings";
    homepage = "https://github.com/hsoft/sphinx-autodoc-annotation";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
