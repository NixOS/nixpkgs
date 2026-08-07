{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  incremental,
  python-dateutil,
  twisted,
}:

buildPythonPackage rec {
  pname = "wokkel";
  version = "18.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ralphm";
    repo = "wokkel";
    tag = version;
    hash = "sha256-vIs9Zo8o7TWUTIqJG9SEHQd63aJFCRhj6k45IuxoCes=";
  };

  patches = [
    # Fixes compat with current-day twisted
    # https://github.com/ralphm/wokkel/pull/32 with all the CI & doc changes excluded
    ./0001-Remove-py2-compat.patch

    # Fix test failure with Twisted >= 26
    # https://github.com/ralphm/wokkel/issues/33
    (fetchpatch2 {
      name = "fix-test-for-twisted-26.patch";
      url = "https://salsa.debian.org/python-team/packages/wokkel/-/raw/f9425d127449a47a7578a01a1b802b7b26b0677f/debian/patches/fix-test-for-twisted-26.patch";
      hash = "sha256-gyVKKqDCFFXyA5LG0q2p8SWIh9DJCUkdK6slOaYsAw0=";
    })
  ];

  postPatch = ''
    substituteInPlace wokkel/muc.py \
      --replace-fail "twisted.python.constants" "constantly"
  '';

  build-system = [ setuptools ];

  dependencies = [
    incremental
    python-dateutil
    twisted
  ];

  nativeCheckInputs = [ twisted ];

  checkPhase = ''
    runHook preCheck

    trial wokkel

    runHook postCheck
  '';

  pythonImportsCheck = [
    "twisted.plugins.server"
    "wokkel.disco"
    "wokkel.muc"
    "wokkel.pubsub"
  ];

  meta = {
    description = "Twisted Jabber support library";
    longDescription = ''
      Wokkel is collection of enhancements on top of the Twisted networking framework, written in Python. It mostly
      provides a testing ground for enhancements to the Jabber/XMPP protocol implementation as found in
      Twisted Words, that are meant to eventually move there.
    '';
    homepage = "https://github.com/ralphm/wokkel"; # wokkel.ik.nu is dead
    changelog = "https://github.com/ralphm/wokkel/blob/${version}/NEWS.rst";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ethancedwards8 ];
    teams = [ lib.teams.ngi ];
  };
}
