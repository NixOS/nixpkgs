{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "shippai";
  # Please make sure that vdirsyncer still builds if you update this package.
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e8d1ca5a742a7ea175cebda3090497d42348517e8d2f05f9854d0f30f1a48ad";
  };

  meta = with stdenv.lib; {
    description = "Use Rust failures as Python exceptions";
    homepage = https://github.com/untitaker/shippai;
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
