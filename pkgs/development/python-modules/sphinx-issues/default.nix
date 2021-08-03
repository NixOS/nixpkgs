{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sphinx-issues";
  version = "1.2.0";

  nativeBuildInputs = [ setuptools-scm ];
  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ sphinx ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wq9yp66xq9scazzc05vgh1n84cyf0gl64vgf2fc1i3sdirr8ll4";
  };

  meta = with lib; {
    description = "A Sphinx extension for linking to your project’s issue tracker";
    homepage = "https://github.com/sloria/sphinx-issues";
    license = with licenses; [ mit ];
  };
}
