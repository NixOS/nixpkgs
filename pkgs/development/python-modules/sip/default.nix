{ lib, stdenv, fetchPypi, buildPythonPackage, packaging, ply, toml, fetchpatch }:

buildPythonPackage rec {
  pname = "sip";
  version = "6.6.2";

  src = fetchPypi {
    pname = "sip";
    inherit version;
    sha256 = "sha256-Dj76wcXf2OUlrlcUCSffJpk+E/WLidFXfDFPQQW/2Q0=";
  };

  patches = [
    # on non-x86 Linux platforms, sip incorrectly detects the manylinux version
    # and PIP will refuse to install the resulting wheel.
    # remove once upstream fixes this, hopefully in 6.5.2
    ./fix-manylinux-version.patch

    # fix issue triggered by QGIS 3.26.x, already fixed upstream
    # in SIP, waiting for release past 6.6.2
    (fetchpatch {
      url = "https://riverbankcomputing.com/hg/sip/raw-diff/323d39a2d602/sipbuild/generator/parser/instantiations.py";
      hash = "sha256-QEQuRzXA+wK9Dt22U/LgIwtherY9pJURGJYpKpJkiok=";
    })
  ];

  propagatedBuildInputs = [ packaging ply toml ];

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
