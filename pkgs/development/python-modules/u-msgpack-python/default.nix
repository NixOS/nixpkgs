{ buildPythonPackage
, lib
, fetchPypi
, glibcLocales
, python
}:

buildPythonPackage rec {
  pname = "u-msgpack-python";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "996e4c4454771f0ff0fd2a7566b1a159d305d3611cd755addf444e3533e2bc54";
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
