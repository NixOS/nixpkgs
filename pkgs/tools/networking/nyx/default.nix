{ lib, pythonPackages }:

with pythonPackages;

buildPythonApplication rec {
  pname = "nyx";
  version = "2.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pm7vfcqr02pzqz4b2f6sw5prxxmgqwr1912am42xmy2i53n7nrq";
  };

  propagatedBuildInputs = [ stem ];

  # ./run_tests.py returns `TypeError: testFailure() takes exactly 1 argument`
  doCheck = false;

  meta = with lib; {
    description = "Command-line monitor for Tor";
    homepage = https://nyx.torproject.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ offline ];
  };
}
