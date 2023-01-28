{ lib, stdenv, fetchPypi, buildPythonPackage, packaging, ply, toml, fetchpatch }:

buildPythonPackage rec {
  pname = "sip";
  version = "6.7.5";

  src = fetchPypi {
    pname = "sip";
    inherit version;
    sha256 = "sha256-llXQieHQxfv2a94RVYqHSYBykTK1vQwq41WsGnuJOrQ=";
  };

  propagatedBuildInputs = [ packaging ply toml ];

  # There aren't tests
  doCheck = false;

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

  pythonImportsCheck = [ "sipbuild" ];

  meta = with lib; {
    description = "Creates C++ bindings for Python modules";
    homepage    = "https://riverbankcomputing.com/";
    license     = licenses.gpl3Only;
    maintainers = with maintainers; [ nrdxp ];
  };
}
