{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "striprtf";
  version = "0.0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "690387117f3341354fddd0957913158d1319c207755c0cc54a614f80248887b2";
  };

  meta = with lib; {
    homepage = "https://github.com/joshy/striprtf";
    description = "A simple library to convert rtf to text";
    maintainers = with maintainers; [ aanderse ];
    license = with licenses; [ bsd3 ];
  };
}
