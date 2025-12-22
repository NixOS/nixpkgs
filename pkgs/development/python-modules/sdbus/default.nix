{
  pkgs,
  lib,
  buildPythonPackage,
  fetchPypi,
  pkg-config,
}:

let
  pname = "sdbus";
  version = "0.14.2";
in
buildPythonPackage {
  format = "setuptools";
  inherit pname version;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pkgs.systemd ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T10TsZbh4d41MR67JWOjLeeRRRow9bmkiUUouph2ZBI=";
  };

  meta = {
    description = "Modern Python library for D-Bus";
    homepage = "https://github.com/python-sdbus/python-sdbus";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ camelpunch ];
    platforms = lib.platforms.linux;
  };
}
