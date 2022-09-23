{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, setuptools-scm
, wcwidth
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wcpp1nkicrswb353yn6xd2x535cpif62nw5rgz33c1wj0wzbdvb";
  };

  nativeBuildInputs = [ setuptools-scm ];
  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = [ wcwidth ];

  preCheck = ''
    export LANG="en_US.UTF-8"
  '';

  # no test no longer available in pypi package
  doCheck = false;
  pythonImportsCheck = [ "prettytable" ];

  meta = with lib; {
    description = "Simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
    homepage = "http://code.google.com/p/prettytable/";
    license = licenses.bsd3;
  };

}
