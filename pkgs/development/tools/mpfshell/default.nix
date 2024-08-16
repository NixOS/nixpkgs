{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  pname = "mpfshell-unstable";
  version = "2020-04-11";

  src = fetchFromGitHub {
    owner = "wendlers";
    repo = "mpfshell";
    rev = "429469fcccbda770fddf7a4277f5db92b1217664";
    sha256 = "0md6ih9vp65dacqy8gki3b2p4v76xb9ijqmxymk4b4f9z684x2m7";
  };

  propagatedBuildInputs = with python3Packages; [
    pyserial colorama websocket-client
  ];

  doCheck = false;
  pythonImportsCheck = [ "mp.mpfshell" ];

  meta = with lib; {
    homepage = "https://github.com/wendlers/mpfshell";
    description = "Simple shell based file explorer for ESP8266 Micropython based devices";
    mainProgram = "mpfshell";
    license = licenses.mit;
  };
}
