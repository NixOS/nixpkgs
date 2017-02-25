{ buildPythonPackage
, lib
, fetchurl
, glibcLocales
, python
}:

let
  pname = "u-msgpack-python";
  version = "2.3.0";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "d8df6bb0e2a838aa227c39cfd14aa147ab32b3df6871001874e9b9da9ce1760c";
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
