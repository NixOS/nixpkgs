{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "shippai";
  # Please make sure that vdirsyncer still builds if you update this package.
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ppwywzg4d12h658682ssmingm6ls6a96p4ak26i2w9d4lf8pfsc";
  };

  meta = with stdenv.lib; {
    description = "Use Rust failures as Python exceptions";
    homepage = https://github.com/untitaker/shippai;
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
