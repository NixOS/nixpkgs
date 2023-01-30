{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, gtest
, xtensor
, pybind11
, numpy
}:

buildPythonPackage rec {
  pname = "xtensor-python";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = pname;
    rev = version;
    sha256 = "17la76hn4r1jv67dzz8x2pzl608r0mnvz854407mchlzj6rhsxza";
  };

  nativeBuildInputs = [ cmake pybind11 ];

  propagatedBuildInputs = [ xtensor numpy ];

  dontUseSetuptoolsBuild = true;
  dontUsePipInstall = true;
  dontUseSetuptoolsCheck = true;

  nativeCheckInputs = [
    gtest
  ];

  meta = with lib; {
    homepage = "https://github.com/xtensor-stack/xtensor-python";
    description = "Python bindings for the xtensor C++ multi-dimensional array library";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lsix ];
  };
}
