{
  pkgs,
  lib,
  buildPythonPackage,
  fetchPypi,
  pkg-config,
}:

let
  pname = "sdbus";
  version = "0.14.1.post0";
in
buildPythonPackage {
  format = "setuptools";
  inherit pname version;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pkgs.systemd ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rjkVqz4/ChFmMuHlh235krlSnoKwtJIAbrIvh5Htbes=";
  };

  meta = {
    description = "Modern Python library for D-Bus";
    homepage = "https://github.com/python-sdbus/python-sdbus";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ camelpunch ];
    platforms = lib.platforms.linux;
  };
}
