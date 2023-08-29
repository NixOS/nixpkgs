{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
}:

buildPythonPackage rec {
  pname = "wheel";
  version = "0.41.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = version;
    hash = "sha256-/EaDJ2zI/ly2BrrGhiZGwiBYDVPYWTki+87UqtCS3bw=";
    postFetch = ''
      cd $out
      mv tests/testdata/unicode.dist/unicodedist/åäö_日本語.py \
        tests/testdata/unicode.dist/unicodedist/æɐø_日本價.py
      patch -p1 < ${./0001-tests-Rename-a-a-o-_-.py-_-.py.patch}
    '';
  };

  nativeBuildInputs = [
    flit-core
  ];

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [ "wheel" ];

  meta = with lib; {
    homepage = "https://github.com/pypa/wheel";
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
