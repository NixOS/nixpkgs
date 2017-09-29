{ buildPythonPackage
, lib
, fetchurl
, glibcLocales
, python
}:

let
  pname = "u-msgpack-python";
  version = "2.4.1";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "2f31fc1b6dd8632c230ea7012470e40f77119f20999274dda6f1afa9c305e590";
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
