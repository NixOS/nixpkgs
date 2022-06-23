{ lib
, buildPythonPackage
, fetchFromGitHub
, systemd
, pkg-config
}:

buildPythonPackage rec {
  pname = "systemd";
  version = "234";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "python-systemd";
    rev = "v${version}";
    sha256 = "1fakw7qln44mfd6pj4kqsgyrhkc6cyr653id34kv0rdnb1bvysrz";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    systemd
  ];

  # No module named 'systemd._journal
  doCheck = false;

  pythonImportsCheck = [
    "systemd.journal"
    "systemd.id128"
    "systemd.daemon"
    "systemd.login"
  ];

  meta = with lib; {
    description = "Python module for native access to the systemd facilities";
    homepage = "http://www.freedesktop.org/software/systemd/python-systemd/";
    license = licenses.lgpl21Plus;
  };
}
