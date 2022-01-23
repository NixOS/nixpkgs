{ stdenv
, lib
, fetchgit
, pkg-config
, meson
, ninja
, systemd
, liburing
, zstd
}:

stdenv.mkDerivation rec {
  pname = "plocate";
  version = "1.1.14";

  src = fetchgit {
    url = "https://git.sesse.net/plocate";
    rev = version;
    sha256 = "sha256-SgvCy03H5aKolbkI1dg/0G5VwT3TdSGenn2h9H4gfTY=";
  };

  postPatch = ''
    sed -i meson.build \
      -e '/mkdir\.sh/d'
  '';

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ systemd liburing zstd ];

  mesonFlags = [
    "-Dsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dsharedstatedir=/var/lib"
  ];

  meta = with lib; {
    description = "Much faster locate";
    homepage = "https://plocate.sesse.net/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg SuperSandro2000 ];
    platforms = platforms.linux;
  };
}
