{ lib
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, buildPythonPackage
, pytest
, pkg-config
, cairo
, python
}:

buildPythonPackage rec {
  pname = "pycairo";
  version = "1.18.2";

  format = "other";

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pycairo";
    rev = "v${version}";
    sha256 = "142145a2whvlk92jijrbf3i2bqrzmspwpysj0bfypw0krzi0aa6j";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/pygobject/pycairo/commit/678edd94d8a6dfb5d51f9c3549e6ee8c90a73744.patch";
      sha256 = "sha256-HmP69tUGYxZvJ/M9FJHwHTCjb9Kf4aWRyMT4wSymrT0=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    cairo
  ];

  # HACK: Don't use the pytestCheckHook because PYTHONPATH
  # will be added by the Python setuptook breaking meson.
  checkPhase = ''
    ${pytest}/bin/pytest
  '';

  mesonFlags = [
    # This is only used for figuring out what version of Python is in
    # use, and related stuff like figuring out what the install prefix
    # should be, but it does need to be able to execute Python code.
    "-Dpython=${python.pythonOnBuildForHost.interpreter}"
  ];

  meta = with lib; {
    description = "Python 2 bindings for cairo";
    homepage = "https://pycairo.readthedocs.io/";
    license = with licenses; [ lgpl21Only mpl11 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
