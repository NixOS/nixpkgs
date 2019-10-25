{ lib, pkgs, buildPythonPackage, fetchPypi, isPy3k
, numpy
}:

buildPythonPackage rec {
  pname = "arrayqueues";
  version = "1.2.0b0";
  disabled = !isPy3k;
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py3";
    sha256 = "56765037b3879ccc26a793c01c06ad87c628eb42de1700ac2b8b721b0fada50f";
  };

  propagatedBuildInputs = [
    numpy
  ];

  meta = {
    homepage = "https://github.com/portugueslab/arrayqueues";
    description = "Multiprocessing queues for numpy arrays using shared memory";
    license = lib.licenses.mit;
    maintainer = with lib.maintainers; [ tbenst ];
  };
}
