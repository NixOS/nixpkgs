{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "shippai";
  # Please make sure that vdirsyncer still builds if you update this package.
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "088rwff3jx23h1glcd29sacd9znxrx5qwq3sbrx0jlmqc2z9syxz";
  };

  meta = with stdenv.lib; {
    description = "Use Rust failures as Python exceptions";
    homepage = https://github.com/untitaker/shippai;
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
