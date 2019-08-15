{ buildPythonPackage
, fetchPypi
, six
, numpy
, pillow
, pytorch
, lib
}:

buildPythonPackage rec {
  version = "0.2.1";
  pname   = "torchvision";

  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "18gvdabkmzfjg47ns0lw38mf85ry28nq1mas5rzlwvb4l5zmw2ms";
  };

  propagatedBuildInputs = [ six numpy pillow pytorch ];

  meta = {
    description = "PyTorch vision library";
    homepage    = https://pytorch.org/;
    license     = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ericsagnes ];
  };
}
