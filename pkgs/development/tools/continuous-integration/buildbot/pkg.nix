{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  buildbot,
}:

buildPythonPackage rec {
  pname = "buildbot_pkg";
  inherit (buildbot) version;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZgDHPC2j3vV3m7wBZhUUh/Th/oGKq+8RxnfQ71Cr6oY=";
  };

  postPatch = ''
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
    maintainers = teams.buildbot.members;
    license = licenses.gpl2;
  };
}
