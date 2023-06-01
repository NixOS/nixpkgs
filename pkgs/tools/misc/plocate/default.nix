{ config
, stdenv
, lib
, fetchgit
, fetchpatch
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
  version = "1.1.17";

  src = fetchgit {
    url = "https://git.sesse.net/plocate";
    rev = version;
    sha256 = "sha256-EcWzvbY8ey5asEJxUeSl10ozApgg+wL5o8NCNw7/W7k=";
  };

  patches = [
    # fix redefinition error
    (fetchpatch {
      url = "https://git.sesse.net/?p=plocate;a=patch;h=0125004cd28c5f9124632b594e51dde73af1691c";
      revert = true;
      sha256 = "sha256-1TDpxIdpDZQ0IZ/wGG91RVZDrpMpWkvhRF8oE0CJWIY=";
    })
  ];

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
