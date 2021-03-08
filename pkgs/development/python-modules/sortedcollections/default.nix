{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "sortedcollections";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "grantjenks";
    repo = "python-sortedcollections";
    rev = "v${version}";
    sha256 = "06ifkbhkj5fpsafibw0fs7b778g7q0gd03crvbjk04k0f3wjxc5z";
  };

  propagatedBuildInputs = [ sortedcontainers ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sortedcollections" ];

  meta = with lib; {
    description = "Python Sorted Collections";
    homepage = "http://www.grantjenks.com/docs/sortedcollections/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
