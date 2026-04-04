{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  file,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "sqlmap";
  version = "1.10.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-PRZvDidyvwjJ7oXU9Mu6eObHm08wWCjjHx6BPjP/Dlg=";
  };

  postPatch = ''
    substituteInPlace sqlmap/thirdparty/magic/magic.py --replace "ctypes.util.find_library('magic')" \
      "'${file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}'"

    # the check for the last update date does not work in Nix,
    # since the timestamp of the all files in the nix store is reset to the unix epoch
    echo 'LAST_UPDATE_NAGGING_DAYS = float("inf")' >> sqlmap/lib/core/settings.py
  '';

  build-system = [ setuptools ];

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [ "sqlmap" ];

  meta = {
    description = "Automatic SQL injection and database takeover tool";
    homepage = "https://sqlmap.org";
    changelog = "https://github.com/sqlmapproject/sqlmap/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ bennofs ];
    mainProgram = "sqlmap";
  };
})
