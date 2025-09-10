{
  lib,
  buildPythonPackage,
  isPy3k,
  buildbot,
}:

buildPythonPackage {
  format = "setuptools";
  pname = "buildbot_pkg";
  inherit (buildbot) src version;

  postPatch = ''
    cd pkg
    # Their listdir function filters out `node_modules` folders.
    # Do we have to care about that with Nix...?
    substituteInPlace buildbot_pkg.py --replace "os.listdir = listdir" ""
  '';

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "buildbot_pkg" ];

  disabled = !isPy3k;

  meta = with lib; {
    homepage = "https://buildbot.net/";
    description = "Buildbot Packaging Helper";
    teams = [ teams.buildbot ];
    license = licenses.gpl2;
  };
}
