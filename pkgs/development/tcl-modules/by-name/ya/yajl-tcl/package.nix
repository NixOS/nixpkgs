{
  lib,
  mkTclDerivation,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  yajl,
}:

mkTclDerivation (finalAttrs: {
  pname = "yajl-tcl";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "yajl-tcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MKm/cfZxPoxpsHuZf9qSXZXzdFbDb7IGeJgMHGh9bcE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    yajl
  ];

  buildFlags = [
    # https://github.com/flightaware/yajl-tcl/pull/45
    "CFLAGS=-std=gnu17"
  ];

  meta = {
    description = "Tcl bindings for Yet Another JSON Library";
    homepage = "https://github.com/flightaware/yajl-tcl";
    changelog = "https://github.com/flightaware/yajl-tcl/blob/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fgaz ];
  };
})
