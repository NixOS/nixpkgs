{ lib, stdenv, buildPythonPackage, fetchFromGitHub
, pytestCheckHook, pytest-benchmark, enum34, numpy, arrow, ruamel-yaml
}:

buildPythonPackage rec {
  pname   = "construct";
  version = "2.10.54";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1mqspsn6bf3ibvih1zna2glkg8iw7vy5zg9gzg0d1m8zcndk2c48";
  };

  checkInputs = [ pytestCheckHook enum34 numpy ];

  # these have dependencies that are broken on Python 2
  disabledTestPaths = [
    "tests/gallery/test_gallery.py"
    "tests/test_benchmarks.py"
    "tests/test_compiler.py"
  ];

  disabledTests = [
    "test_benchmarks"
    "test_timestamp"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_multiprocessing"
  ];

  meta = with lib; {
    description = "Powerful declarative parser (and builder) for binary data";
    homepage = "https://construct.readthedocs.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
