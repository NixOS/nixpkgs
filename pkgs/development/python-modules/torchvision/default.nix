{ buildPythonPackage
, fetchPypi
, six
, numpy
, pillow
, pytorch
, lib }:

buildPythonPackage rec {
  version = "0.1.9";
  pname   = "torchvision";
  name    = "${pname}-${version}";

  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "016rjfh9w1x4xpw15ryxsvq3j2li17nd3a7qslnf3241hc6vdcwf";
  };

  propagatedBuildInputs = [ six numpy pillow pytorch ];

  meta = {
    description = "PyTorch vision library";
    homepage    = http://pytorch.org/;
    license     = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ericsagnes ];
  };
}
