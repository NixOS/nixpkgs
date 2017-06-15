{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {

  name = "${pname}-${version}";
  pname = "serpent";
  version = "1.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kh76xjkn9ilcjgipg4yai4gx6zhv2nrvbvm6pgp36c8gy1jqswl";
  };

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';
  
  meta = with stdenv.lib; {
    description = "serializer for literal Python expressions";
    homepage = https://github.com/irmen/Serpent;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll ];
    };
}
