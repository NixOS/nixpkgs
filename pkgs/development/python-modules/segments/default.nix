{ fetchPypi, buildPythonPackage, python3Packages, lib, isPy3k }:

buildPythonPackage rec {
  pname = "segments";
  version = "2.1.3";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bw5621aihgfz83623a22ihzs053m1m5wq5ivxa40i16i1gq897v";
  };

  propagatedBuildInputs = with python3Packages; [
    regex
    csvw
    clldutils
  ];

  meta = with lib; {
    description = "Unicode Standard tokenization routines and orthography profile segmentation";
    homepage = "https://github.com/cldf/segments";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
