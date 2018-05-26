{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zipfile36";
  version = "0.1.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a78a8dddf4fa114f7fe73df76ffcce7538e23433b7a6a96c1c904023f122aead";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest test_zipfile.py
  '';

  # Only works with Python 3.x.
  # Not supposed to be used with 3.6 and up.
  disabled = !(isPy3k && (pythonOlder "3.6"));

  meta = {
    description = "Read and write ZIP files - backport of the zipfile module from Python 3.6";
    homepage = https://gitlab.com/takluyver/zipfile36;
    license = lib.licenses.psfl;
    maintainers = lib.maintainers.fridh;
  };
}
