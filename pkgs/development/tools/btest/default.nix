{ lib, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  pname = "btest";
  version = "0.59";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ic2c1gvp448d5h0b9vsk6813hfffznb26b5si7jk1dhqb27hva4";
  };

  doCheck = false;

  meta = with lib; {
    description = "A Simple Driver for Basic Unit Tests";
    homepage = "https://github.com/zeek/btest";
    license = licenses.bsd3;
    maintainers = [ maintainers.tobim ];
    platforms = platforms.all;
  };
}
