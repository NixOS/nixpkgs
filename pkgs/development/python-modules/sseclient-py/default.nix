{ buildPythonPackage, fetchFromGitHub, lib, python }:

buildPythonPackage rec {
  pname = "sseclient-py";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "mpetazzoni";
    repo = "sseclient";
    rev = "sseclient-py-${version}";
    sha256 = "sha256-rNiJqR7/e+Rhi6kVBY8gZJZczqSUsyszotXkb4OKfWk=";
  };

  # based on tox.ini
  checkPhase = ''
    ${python.interpreter} tests/unittests.py
  '';

  meta = with lib; {
    description = "Pure-Python Server Side Events (SSE) client";
    homepage = "https://github.com/mpetazzoni/sseclient";
    changelog = "https://github.com/mpetazzoni/sseclient/releases/tag/sseclient-py-${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
