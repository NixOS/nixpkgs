{ stdenv, buildPythonPackage, fetchFromGitHub, systemd, pkgconfig }:

buildPythonPackage rec {
  name = "python-systemd-${version}";
  version = "234";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "python-systemd";
    rev = "v${version}";
    sha256 = "1fakw7qln44mfd6pj4kqsgyrhkc6cyr653id34kv0rdnb1bvysrz";
  };

  buildInputs = [ systemd ];
  nativeBuildInputs = [ pkgconfig ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python module for native access to the systemd facilities";
    homepage = http://www.freedesktop.org/software/systemd/python-systemd/;
    license = licenses.lgpl21;
  };
}
