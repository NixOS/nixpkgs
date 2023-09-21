{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "xlsx2csv";
  version = "0.8.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fs1tK8JCby5DL0/awSIR4ZdtPLtl+QM+Htpl7dogReM=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  meta = with lib; {
    homepage = "https://github.com/dilshod/xlsx2csv";
    description = "Convert xlsx to csv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jb55 ];
  };
}
