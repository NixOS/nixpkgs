{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  name = "mpfshell-${version}";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "wendlers";
    repo = "mpfshell";
    rev = version;
    sha256 = "1n4ap4yfii54y125f9n9krc0lc0drwg3hsq4z6g89xbswdx9sygr";
  };

  propagatedBuildInputs = with python3Packages; [
    pyserial colorama websocket_client
  ];

  meta = with lib; {
    homepage = https://github.com/wendlers/mpfshell;
    description = "A simple shell based file explorer for ESP8266 Micropython based devices";
    license = licenses.mit;
  };
}
