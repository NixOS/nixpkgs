{ lib, buildPythonPackage, fetchPypi, webencodings, pytestrunner, pytestcov, pytest-flake8, pytest-isort, glibcLocales }:

buildPythonPackage rec {
  pname = "tinycss2";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c53c2c0e914c7711c295b3101bcc78e0b7eda23ff20228a936efe11cdcc7136";
  };

  propagatedBuildInputs = [ webencodings ];

  checkInputs = [ pytestrunner pytestcov pytest-flake8 pytest-isort glibcLocales ];

  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "Low-level CSS parser for Python";
    homepage = https://github.com/Kozea/tinycss2;
    license = licenses.bsd3;
  };
}
