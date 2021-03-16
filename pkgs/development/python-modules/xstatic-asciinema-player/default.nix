{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "XStatic-asciinema-player";
  version = "2.6.1.1";


  src = fetchPypi {
    inherit pname version;
    sha256 = "c80e960b4ebb4adf360e6e92b5a08a756ad106198d7a6b307ad20ef22a1d7dcc";
  };

  doCheck = false; # pypi version doesn't include tests

  meta = {
    description = "asciinema-player packaged for setuptools";
    longDescription = ''
      Web player for terminal session recordings (as produced by asciinema recorder)
      that you can use on your website by simply adding <asciinema-player> tag
    '';
    homepage = "https://github.com/asciinema/asciinema-player";
    license = lib.licenses.asl20;
  };
}
