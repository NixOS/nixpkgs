{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec{
  pname = "toolz";
  version = "0.8.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l3czks4xy37i8099waxk2fdz5g0k1dwys2mkhlxc0b0886cj4sa";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    # https://github.com/pytoolz/toolz/issues/357
    rm toolz/tests/test_serialization.py
    nosetests toolz/tests
  '';

  meta = {
    homepage = "http://github.com/pytoolz/toolz/";
    description = "List processing tools and functional utilities";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}