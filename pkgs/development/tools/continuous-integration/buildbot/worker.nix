{
  lib,
  buildPythonPackage,
  buildbot,
  stdenv,

  # patch
  coreutils,

  # build system
  setuptools,

  # propagates
  autobahn,
  msgpack,
  twisted,

  # tests
  parameterized,
  psutil,

  # passthru
  nixosTests,
}:

buildPythonPackage {
  pname = "buildbot_worker";
  inherit (buildbot) src version;
  pyproject = true;

  postPatch = ''
    cd worker
    touch buildbot_worker/py.typed
    substituteInPlace buildbot_worker/scripts/logwatcher.py \
      --replace /usr/bin/tail "${coreutils}/bin/tail"
  '';

  build-system = [ setuptools ];

  dependencies = [
    autobahn
    msgpack
    twisted
  ];

  nativeCheckInputs = [
    parameterized
    psutil
  ];

  passthru.tests = {
    smoke-test = nixosTests.buildbot;
  };

  meta = {
    homepage = "https://buildbot.net/";
    description = "Buildbot Worker Daemon";
    teams = [ lib.teams.buildbot ];
    license = lib.licenses.gpl2;
  };
}
