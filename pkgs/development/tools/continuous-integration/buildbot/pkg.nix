{
  lib,
  buildPythonPackage,
  setuptools,
  isPy3k,
  buildbot,
}:

buildPythonPackage {
  pname = "buildbot_pkg";
  inherit (buildbot) src version;
  pyproject = true;

  postPatch = ''
    cd pkg
    # Their listdir function filters out `node_modules` folders.
    # Do we have to care about that with Nix...?
    substituteInPlace buildbot_pkg.py --replace "os.listdir = listdir" ""
  '';

  build-system = [ setuptools ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "buildbot_pkg" ];

  disabled = !isPy3k;

  meta = {
    homepage = "https://buildbot.net/";
    description = "Buildbot Packaging Helper";
    teams = [ lib.teams.buildbot ];
    license = lib.licenses.gpl2;
  };
}
