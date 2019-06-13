{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "shippai";
  # Please make sure that vdirsyncer still builds if you update this package.
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r6iwvmay8ygn2m15pyjrk9am4mfpk7rkf0lcbcb15pnabixlyzj";
  };

  meta = with stdenv.lib; {
    description = "Use Rust failures as Python exceptions";
    homepage = https://github.com/untitaker/shippai;
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
