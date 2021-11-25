{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "toolz";
  version = "0.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b312d5e15138552f1bda8a4e66c30e236c831b612b2bf0005f8a1df10a4bc33";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests toolz/tests
  '';

  meta = with lib; {
    homepage = "https://github.com/pytoolz/toolz";
    description = "List processing tools and functional utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
