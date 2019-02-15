{ lib, buildPythonPackage, pythonAtLeast, isPy27, fetchPypi
, pyyaml, future, click, shutilwhich }:

buildPythonPackage rec {
  pname = "panflute";
  version = "1.11.2";

  disabled = ! pythonAtLeast "3.5" && !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ybkqqamz3cpxla6jxs7wrnfs4hplb2r4gmbp5qqwfmym1iqa4b1";
  };

  propagatedBuildInputs = [ pyyaml future click shutilwhich ];

  meta = with lib; {
    description = "Pythonic pandocfilters with extra helper functions";
    homepage = http://scorreia.com/software/panflute/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ leenaars ];
  };
}
