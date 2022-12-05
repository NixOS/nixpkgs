{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "toolz";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iMVwhhxEDuPy9gN8RlRhMij/QMk6bCXg66cNFygsYZQ=";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/pytoolz/toolz";
    description = "List processing tools and functional utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
