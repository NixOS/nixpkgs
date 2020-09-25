{ stdenv
, buildPythonPackage
, fetchPypi
, pep8
}:

buildPythonPackage rec {
  pname = "setuptools-pep8";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03084wkc6i5i3w2ldpr7mgkdc029p74n0wnskcj2jmq1jiscs87n";
  };

  propagatedBuildInputs = [
    pep8
  ];

  meta = with stdenv.lib; {
    description = "This package exposes the pep8 style guide checker as a sub-command of setup.py";
    homepage = "https://pypi.python.org/pypi/setuptools-pep8";
    license = licenses.bsd3;
    maintainers = with maintainers; [ doronbehar ];
  };

}
