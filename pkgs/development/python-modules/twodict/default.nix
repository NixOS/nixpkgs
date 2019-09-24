{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "twodict";
  version = "1.2";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0ifv7dv18jn2lg0a3l6zdlvmmlda2ivixfjbsda58a2ay6kxznr0";
  };

  meta = with lib; {
    homepage = "https://github.com/MrS0m30n3/twodict/wiki";
    description = "Two way ordered dictionary";
    license = licenses.unlicense;
    maintainers = with maintainers; [ alexarice ];
  };
}
