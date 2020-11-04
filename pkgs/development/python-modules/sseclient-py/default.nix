{ buildPythonPackage, fetchFromGitHub, lib, python }:

buildPythonPackage rec {
  pname = "sseclient-py";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "mpetazzoni";
    repo = "sseclient";
    rev = "sseclient-py-${version}";
    sha256 = "0iar4w8gryhjzqwy5k95q9gsv6xpmnwxkpz33418nw8hxlp86wfl";
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
