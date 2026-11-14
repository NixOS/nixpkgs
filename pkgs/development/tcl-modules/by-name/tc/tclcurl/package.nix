{
  lib,
  mkTclDerivation,
  fetchFromGitHub,
  curl,
  tcl,
}:

mkTclDerivation (finalAttrs: {
  pname = "tclcurl";
  version = "7.23.0";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "tclcurl-fa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vODXYDLFf/rNq6yWmEa/JFRVrYOGZxTw+IjzILzQpTY=";
  };

  nativeBuildInputs = [
    curl # for curl-config
  ];

  buildInputs = [ curl ];

  makeFlags = [ "LDFLAGS=-lcurl" ];

  meta = {
    description = "Curl support in Tcl";
    homepage = "https://github.com/flightaware/tclcurl-fa";
    changelog = "https://github.com/flightaware/tclcurl-fa/blob/master/ChangeLog.txt";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [ fgaz ];
    broken = tcl.isTcl9;
  };
})
