{ buildPythonPackage
, fetchPypi
, python
, six
, numpy
, pillow
, pytorch
, lib
}:

let
  cpython = "cp${python.sourceVersion.major}${python.sourceVersion.minor}";

  sha256 = {
    cp27 = "0fvj41zlrsd1bhhlypdzip34a67bx0915r1dcvi1rnfq979h0d9j";
    cp35 = "0yz4kgbyrc6k6hh0vf8y9zdj2wyaasns1f9rzmmcz84kzwbvm1cy";
    cp36 = "1mjy0aqdziwinj5iqz24p8z19glfavmp4ngzmwchg733pwqx98zy";
    cp37 = "1zmgwnhsr0ackr2h9cpp5yw3y13pp7fj76zb11jkalpb158fr5m6";
    cp38 = "11bsx74m0aly54j9c2ab5bjf7fk89hlr8v1scfi5wb6y779m8hxa";
  }."${cpython}";
in buildPythonPackage rec {
  pname = "torchvision";
  version = "0.5.0";

  format = "wheel";

  src = fetchPypi {
    inherit pname version sha256;
    format = "wheel";

    python = cpython;
    abi = if cpython == "cp38"
      then cpython
      else "${cpython}m";
    platform = "manylinux1_x86_64";
  };

  propagatedBuildInputs = [ six numpy pillow pytorch ];

  meta = {
    description = "PyTorch vision library";
    homepage    = "https://pytorch.org/";
    license     = lib.licenses.bsd3;
    platforms   = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ericsagnes ];
  };
}
