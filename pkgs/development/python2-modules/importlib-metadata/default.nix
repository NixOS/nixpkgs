{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  zipp,
  pathlib2,
  contextlib2,
  configparser,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "importlib-metadata";
  version = "2.1.1";

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    sha256 = "1pdmsmwagimn0lsl4x7sg3skcr2fvzqpv2pjd1rh7yrm5gzrxpmq";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs =
    [ zipp ]
    ++ lib.optionals (!isPy3k) [
      pathlib2
      contextlib2
      configparser
    ];

  # Cyclic dependencies
  doCheck = false;

  pythonImportsCheck = [ "importlib_metadata" ];

  meta = with lib; {
    description = "Read metadata from Python packages";
    homepage = "https://importlib-metadata.readthedocs.io/";
    license = licenses.asl20;
  };
}
