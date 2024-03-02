{ lib
, buildPythonPackage
, fetchPypi
, buildbot
, stdenv

# patch
, coreutils

# propagates
, autobahn
, future
, msgpack
, twisted

# tests
, parameterized
, psutil
, setuptools-trial

# passthru
, nixosTests
}:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  inherit (buildbot) version;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7zpf1Xl5dYPJk8V5PQCx/v+sE9kH23UWM9QbE0fH4tA=";
  };

  postPatch = ''
    substituteInPlace buildbot_worker/scripts/logwatcher.py \
      --replace /usr/bin/tail "${coreutils}/bin/tail"
  '';

  nativeBuildInputs = [
    setuptools-trial
  ];

  propagatedBuildInputs = [
    autobahn
    future
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
    broken = stdenv.isDarwin; # https://hydra.nixos.org/build/243534318/nixlog/6
  };
})
