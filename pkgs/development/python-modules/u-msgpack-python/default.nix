{ buildPythonPackage
, lib
, fetchPypi
, glibcLocales
, python
}:

buildPythonPackage rec {
  pname = "u-msgpack-python";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ff18ae3721fa75571f9329c08f7c0120416a6ae36194bd8674f65b3b78d0702";
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
