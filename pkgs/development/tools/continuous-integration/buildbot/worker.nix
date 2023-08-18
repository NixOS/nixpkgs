{ lib
, buildPythonPackage
, fetchPypi
, buildbot

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
, setuptoolsTrial

# passthru
, nixosTests
}:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  inherit (buildbot) version;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L7TKo+4RDqHVVB/0ujR3jDxD+emvcEHdHTLyHe9jdk4=";
  };

  postPatch = ''
    substituteInPlace buildbot_worker/scripts/logwatcher.py \
      --replace /usr/bin/tail "${coreutils}/bin/tail"
  '';

  nativeBuildInputs = [
    setuptoolsTrial
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
    maintainers = with maintainers; [ ryansydnor lopsided98 ];
    license = licenses.gpl2;
  };
})
