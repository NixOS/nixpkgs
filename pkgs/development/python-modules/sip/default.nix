{ lib, stdenv, fetchPypi, buildPythonPackage, packaging, toml }:

buildPythonPackage rec {
  pname = "sip";
  version = "6.1.1";

  src = fetchPypi {
    pname = "sip";
    inherit version;
    sha256 = "083ykzg7zbvrfrg3ram2vx93zrmhpm817kf9bkhw8r6pzkr5mljj";
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
    homepage    = "https://riverbankcomputing.com/";
    license     = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
