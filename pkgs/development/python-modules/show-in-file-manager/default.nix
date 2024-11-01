{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  argparse-manpage,
  setuptools,
  packaging,
  pyxdg,
}:

buildPythonPackage rec {
  pname = "show-in-file-manager";
  version = "1.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7ROhgKHUj9iP3UxYv7yzhgJoZBo4gFGSyBTUE4cZLYQ=";
  };

  nativeBuildInputs = [
    argparse-manpage
    setuptools
  ];

  propagatedBuildInputs = [ packaging ] ++ lib.optional (stdenv.hostPlatform.isLinux) pyxdg;

  meta = with lib; {
    homepage = "https://github.com/damonlynch/showinfilemanager";
    description = "Open the system file manager and select files in it";
    mainProgram = "showinfilemanager";
    longDescription = ''
      Show in File Manager is a Python package to open the system file
      manager and optionally select files in it. The point is not to
      open the files, but to select them in the file manager, thereby
      highlighting the files and allowing the user to quickly do
      something with them.
    '';
    license = licenses.mit;
    maintainers = [ ];
  };
}
