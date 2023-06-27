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
, mock
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
    hash = "sha256-et0R0pNxtL5QCgHRT1/q5t+hb6cLl6NU3AowzT/WC90=";
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
    mock
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
