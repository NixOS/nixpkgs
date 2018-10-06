{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "shippai";
  # Please make sure that vdirsyncer still builds if you update this package.
  version = "0.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87cc9899212d917031853becd7cb14808181289c3c329b1418e9b4b6aae93c80";
  };

  meta = with stdenv.lib; {
    description = "Use Rust failures as Python exceptions";
    homepage = https://github.com/untitaker/shippai;
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
