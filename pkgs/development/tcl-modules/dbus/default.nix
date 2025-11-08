{
  lib,
  mkTclDerivation,
  fetchzip,
  pkg-config,
  dbus,
}:

mkTclDerivation rec {
  pname = "dbus";
  version = "4.1";

  src = fetchzip {
    url = "https://chiselapp.com/user/schelte/repository/dbus/uv/dbus-${version}.tar.gz";
    hash = "sha256-8VIw475Q9kRh6UV6FxWCXKLKasqM1z58ed0rMgzEX3I=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  meta = {
    description = "DBus bindings for Tcl";
    homepage = "https://chiselapp.com/user/schelte/repository/dbus/home";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
