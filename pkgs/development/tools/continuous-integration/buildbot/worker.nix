{
  lib,
  buildPythonPackage,
  buildbot,
  stdenv,

  # patch
  coreutils,

  # propagates
  autobahn,
  msgpack,
  twisted,

  # tests
  parameterized,
  psutil,
  setuptools-trial,

  # passthru
  nixosTests,
}:

buildPythonPackage ({
  pname = "buildbot_worker";
  inherit (buildbot) src version;

  postPatch = ''
    cd worker
    touch buildbot_worker/py.typed
    substituteInPlace buildbot_worker/scripts/logwatcher.py \
      --replace /usr/bin/tail "${coreutils}/bin/tail"
  '';

  nativeBuildInputs = [
    setuptools-trial
  ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    homepage = "https://buildbot.net/";
    description = "Buildbot Worker Daemon";
    maintainers = teams.buildbot.members;
    license = licenses.gpl2;
    broken = stdenv.hostPlatform.isDarwin; # https://hydra.nixos.org/build/243534318/nixlog/6
  };
})
