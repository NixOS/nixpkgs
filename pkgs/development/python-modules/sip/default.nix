{ lib, stdenv, fetchPypi, buildPythonPackage, packaging, toml }:

buildPythonPackage rec {
  pname = "sip";
  version = "5.5.0";

  src = fetchPypi {
    pname = "sip";
    inherit version;
    sha256 = "1idaivamp1jvbbai9yzv471c62xbqxhaawccvskaizihkd0lq0jx";
  };

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
    homepage    = "http://www.riverbankcomputing.co.uk/";
    license     = licenses.gpl3Only;
    maintainers = with maintainers; [ eduardosm ];
  };
}
