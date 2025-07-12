{
  lib,
  mkTclDerivation,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  yajl,
}:

mkTclDerivation rec {
  pname = "yajl-tcl";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "yajl-tcl";
    tag = "v${version}";
    hash = "sha256-MKm/cfZxPoxpsHuZf9qSXZXzdFbDb7IGeJgMHGh9bcE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    yajl
  ];

  meta = {
    description = "Tcl bindings for Yet Another JSON Library";
    homepage = "https://github.com/flightaware/yajl-tcl";
    changelog = "https://github.com/flightaware/yajl-tcl/blob/${src.tag}/ChangeLog";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
