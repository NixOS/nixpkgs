{ buildPythonPackage
, lib
, fetchPypi
, glibcLocales
, python
}:

buildPythonPackage rec {
  pname = "u-msgpack-python";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "754edb07eaee39a9686a99823892e3a1be4e0948d9cc5c717946750c27643c9c";
  };

  LC_ALL="en_US.UTF-8";

  buildInputs = [ glibcLocales ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = {
    description = "A portable, lightweight MessagePack serializer and deserializer written in pure Python";
    homepage = "https://github.com/vsergeev/u-msgpack-python";
    license = lib.licenses.mit;
  };

}
