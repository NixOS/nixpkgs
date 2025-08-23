{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
}:

buildPythonPackage rec {
  pname = "wheel";
  version = "0.46.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "wheel";
    tag = version;
    hash = "sha256-iyGfGr3pLVZSEIHetjsPbIIXkuXrmIPiSqqOw31l9Qw=";
  };

  nativeBuildInputs = [ flit-core ];

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [ "wheel" ];

  meta = with lib; {
    homepage = "https://github.com/pypa/wheel";
    description = "Built-package format for Python";
    mainProgram = "wheel";
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
