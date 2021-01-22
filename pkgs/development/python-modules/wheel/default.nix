{ lib
, buildPythonPackage
, fetchFromGitHub
, bootstrapped-pip
, setuptools
}:

buildPythonPackage rec {
  pname = "wheel";
  version = "0.36.2";
  format = "other";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = version;
    sha256 = "sha256-8lK2UvqBIxUYm6IOuT+Jk71wYbEEjvI7typS3749N9g=";
    name = "${pname}-${version}-source";
  };

  nativeBuildInputs = [
    bootstrapped-pip
    setuptools
  ];

  # No tests in archive
  doCheck = false;
  pythonImportsCheck = [ "wheel" ];

  # We add this flag to ignore the copy installed by bootstrapped-pip
  pipInstallFlags = [ "--ignore-installed" ];

  meta = with lib; {
    homepage = "https://bitbucket.org/pypa/wheel/";
    description = "A built-package format for Python";
    longDescription = ''
      This library is the reference implementation of the Python wheel packaging standard,
      as defined in PEP 427.

      It has two different roles:

      - A setuptools extension for building wheels that provides the bdist_wheel setuptools command
      - A command line tool for working with wheel files

      It should be noted that wheel is not intended to be used as a library,
      and as such there is no stable, public API.
    '';
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
