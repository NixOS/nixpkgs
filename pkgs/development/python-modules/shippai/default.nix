{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "shippai";
  # Please make sure that vdirsyncer still builds if you update this package.
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8nva41L2lrDYYhS4mc+8rpKq0szS3xKqsM8jr+rm0WQ=";
  };

  meta = with lib; {
    description = "Use Rust failures as Python exceptions";
    homepage = "https://github.com/untitaker/shippai";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
