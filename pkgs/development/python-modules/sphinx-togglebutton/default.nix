{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, sphinx
, docutils
}:

buildPythonPackage rec {
  pname = "sphinx-togglebutton";
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "41cbe2f87459eade8dc5718bb56146e8e113a05fb97459b90472470f0d357b55";
  };

  propagatedBuildInputs = [
    setuptools
    wheel
    sphinx
    docutils
  ];

  meta = with lib; {
    description = "Toggle page content and collapse admonitions in Sphinx";
    homepage = https://github.com/executablebooks/sphinx-togglebutton;
    license = licenses.mit;
  };
}