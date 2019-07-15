{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "subprocess32-ext";
  version = "3.2.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06rp8w5a7b1xp8v8ga79ymxb00qfh8h936rk022bn1lpxy0gmjpj";
  };

  buildInputs = [ ];

  doCheck = false;

  meta = {
    homepage = https://github.com/google/python-subprocess32;
    description = "backport of subprocess model";
    maintainers = with lib.maintainers; [ mog ];
    license = lib.licenses.psf;
  };
}
