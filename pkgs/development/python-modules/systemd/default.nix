{ lib, buildPythonPackage, fetchFromGitHub, systemd, pkg-config }:

buildPythonPackage rec {
  pname = "systemd";
  version = "234";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "python-systemd";
    rev = "v${version}";
    sha256 = "1fakw7qln44mfd6pj4kqsgyrhkc6cyr653id34kv0rdnb1bvysrz";
  };

  buildInputs = [ systemd ];
  nativeBuildInputs = [ pkg-config ];

  doCheck = false;

  meta = with lib; {
    description = "Python module for native access to the systemd facilities";
    homepage = "http://www.freedesktop.org/software/systemd/python-systemd/";
    license = licenses.lgpl21;
  };
}
