{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, setuptools
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-autodoc-typehints";
  version = "1.12.0";

  nativeBuildInputs = [ setuptools-scm ];
  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ sphinx ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0llzia8clzq7vvpwf0ifr1cxjk73fjg3d79rn60p5170vgcifdhr";
  };

  meta = with lib; {
    description =
    ''
      Extension that allows you to use Python 3 annotations for documenting
      acceptable argument types and return value types of functions
    '';
    homepage = "https://github.com/agronholm/sphinx-autodoc-typehints";
    license = with licenses; [ mit ];
  };
}
