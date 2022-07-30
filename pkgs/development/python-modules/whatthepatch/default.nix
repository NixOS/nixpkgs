{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "whatthepatch";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xUDqWRc+CikeGcdC3YtAbFbivgOaYA7bfG/Drku9+p8=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/cscorley/whatthepatch";
    description = "A Python patch parsing library";
    maintainers = with maintainers; [ lilyinstarlight ];
    license = licenses.mit;
  };
}
