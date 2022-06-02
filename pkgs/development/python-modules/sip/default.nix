{ lib, stdenv, fetchPypi, buildPythonPackage, packaging, toml }:

buildPythonPackage rec {
  pname = "sip";
  version = "6.5.1";

  src = fetchPypi {
    pname = "sip";
    inherit version;
    sha256 = "sha256-IE8CQNuJmadJ1jiph7NRhhhD5pI5uBHsPRiBQSw3BqY=";
  };

  patches = [
    # on non-x86 Linux platforms, sip incorrectly detects the manylinux version
    # and PIP will refuse to install the resulting wheel.
    # remove once upstream fixes this, hopefully in 6.5.2
    ./fix-manylinux-version.patch
  ];

  propagatedBuildInputs = [ packaging toml ];

  # There aren't tests
  doCheck = false;

  pythonImportsCheck = [ "sipbuild" ];

  # FIXME: Why isn't this detected automatically?
  # Needs to be specified in pyproject.toml, e.g.:
  # [tool.sip.bindings.MODULE]
  # tags = [PLATFORM_TAG]
  platform_tag =
    if stdenv.targetPlatform.isLinux then
      "WS_X11"
    else if stdenv.targetPlatform.isDarwin then
      "WS_MACX"
    else if stdenv.targetPlatform.isWindows then
      "WS_WIN"
    else
      throw "unsupported platform";

  meta = with lib; {
    description = "Creates C++ bindings for Python modules";
    homepage    = "https://riverbankcomputing.com/";
    license     = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
