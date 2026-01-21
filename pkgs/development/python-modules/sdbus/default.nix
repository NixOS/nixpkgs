{
  pkgs,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  dbus,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sdbus";
  version = "0.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-sdbus";
    repo = "python-sdbus";
    tag = finalAttrs.version;
    hash = "sha256-vRz7RTSI5QjI48YnaC20mbOKl6+yXk/TrFicQ0MDR9Q=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ pkgs.systemd ];

  pythonImportsCheck = [ "sdbus" ];

  nativeCheckInputs = [
    pytestCheckHook
    dbus
  ];

  disabledTestPaths = [
    # try to access /var/lib/dbus/machine-id
    "test/test_proxies.py::TestFreedesktopDbus::test_connection"
    "test/test_sdbus_block.py::TestSync::test_sync"
  ];

  meta = {
    description = "Modern Python library for D-Bus";
    homepage = "https://github.com/python-sdbus/python-sdbus";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ camelpunch ];
    platforms = lib.platforms.linux;
  };
})
