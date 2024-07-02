{ lib, python3Packages, fetchPypi }:

with python3Packages;

buildPythonApplication rec {
  pname = "nyx";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02rrlllz2ci6i6cs3iddyfns7ang9a54jrlygd2jw1f9s6418ll8";
  };

  propagatedBuildInputs = [ stem ];

  postPatch = ''
    # py 3.11 compat fix https://github.com/torproject/nyx/issues/63#issuecomment-1557355542
    find -type f -exec sed -i 's/getargspec/getfullargspec/g' {} \;
  '';

  # ./run_tests.py returns `TypeError: testFailure() takes exactly 1 argument`
  doCheck = false;

  meta = with lib; {
    description = "Command-line monitor for Tor";
    mainProgram = "nyx";
    homepage = "https://nyx.torproject.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ offline ];
  };
}
