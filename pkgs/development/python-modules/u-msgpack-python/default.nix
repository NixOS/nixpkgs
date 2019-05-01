{ buildPythonPackage
, lib
, fetchPypi
, glibcLocales
, python
}:

buildPythonPackage rec {
  pname = "u-msgpack-python";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c02a0654a5e11f8fad532ed634109ed49cdc929f7b972848773e4e0ce52f30c";
  };

  LC_ALL="en_US.UTF-8";

  buildInputs = [ glibcLocales ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = {
    description = "A portable, lightweight MessagePack serializer and deserializer written in pure Python";
    homepage = https://github.com/vsergeev/u-msgpack-python;
    license = lib.licenses.mit;
  };

}
