{ config
, stdenv
, lib
, fetchgit
, pkg-config
, meson
, ninja
, systemd
, liburing
, zstd
}:
let
  dbfile = lib.attrByPath [ "locate" "dbfile" ] "/var/cache/locatedb" config;
in
stdenv.mkDerivation rec {
  pname = "plocate";
  version = "1.1.16";

  src = fetchgit {
    url = "https://git.sesse.net/plocate";
    rev = version;
    sha256 = "sha256-rwvzDr3leve8BQ30+c3l1+q/7+u7FhPQ7iFcvbx/HjM=";
  };

  postPatch = ''
    sed -i meson.build \
      -e '/mkdir\.sh/d'
  '';

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ systemd liburing zstd ];

  mesonFlags = [
    "-Dsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dsharedstatedir=${builtins.dirOf dbfile}"
    "-Ddbpath=${builtins.baseNameOf dbfile}"
  ];

  meta = with lib; {
    description = "Much faster locate";
    homepage = "https://plocate.sesse.net/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg SuperSandro2000 ];
    platforms = platforms.linux;
  };
}
