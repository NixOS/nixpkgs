{ buildPythonPackage, fetchFromGitHub, lib, python }:

buildPythonPackage rec {
  pname = "sseclient-py";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "mpetazzoni";
    repo = "sseclient";
    rev = "sseclient-py-${version}";
    sha256 = "096spyv50jir81xiwkg9l88ycp1897d3443r6gi1by8nkp4chvix";
  };

  # based on tox.ini
  checkPhase = ''
    ${python.interpreter} tests/unittests.py
  '';

  meta = with lib; {
    description = "Pure-Python Server Side Events (SSE) client";
    homepage = "https://github.com/mpetazzoni/sseclient";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
