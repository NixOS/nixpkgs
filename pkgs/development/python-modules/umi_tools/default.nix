{ lib
, gcc
, zlib
, buildPythonPackage
, fetchPypi
, pythonOlder
, numpy
, pandas
, pysam
, future
, six
, regex
, scipy
, matplotlib
, pybktree
}:

buildPythonPackage rec {
  pname = "umi_tools";
  version = "1.1.2";

  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-BEYPDjD8ftIn/hrVESbNHL3bFQLUeWzpjXrGHyUJ1B8=";
  };

  nativeBuildInputs = [ gcc zlib ];
  propagatedBuildInputs = [
    numpy
    pandas
    pysam
    future
    six
    regex
    scipy
    matplotlib
    pybktree
  ];

  meta = with lib; {
    description = "Tools for dealing with unique molecular identifiers";
    homepage = "https://umi-tools.readthedocs.io/en/latest/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aehmlo ];
  };
}
