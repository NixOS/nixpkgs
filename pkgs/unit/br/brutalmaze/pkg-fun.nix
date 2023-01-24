{ lib, fetchFromSourcehut, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "brutalmaze";
  version = "1.1.1";
  format = "flit";
  disabled = python3Packages.pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = pname;
    rev = version;
    sha256 = "1m105iq378mypj64syw59aldbm6bj4ma4ynhc50gafl656fabg4y";
  };

  propagatedBuildInputs = with python3Packages; [
    loca
    palace
    pygame
  ];

  doCheck = false; # there's no test

  meta = with lib; {
    description = "Minimalist thrilling shoot 'em up game";
    homepage = "https://brutalmaze.rtfd.io";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.McSinyx ];
  };
}
