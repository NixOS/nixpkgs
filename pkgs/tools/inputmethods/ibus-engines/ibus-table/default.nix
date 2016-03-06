{ stdenv, fetchurl, pkgconfig
, gtk3, dconf, gobjectIntrospection, ibus, python3, pygobject3 }:

stdenv.mkDerivation rec {
  name = "ibus-table-${version}";
  version = "1.9.11";

  src = fetchurl {
    url = "https://github.com/kaio/ibus-table/releases/download/${version}/${name}.tar.gz";
    sha256 = "14sb89z1inbbhcrbsm5nww8la04ncy2lk32mxfqpi4ghl22ixxqd";
  };

  postPatch = ''
    # Data paths will be set at run-time.
    sed -e "/export IBUS_TABLE_LIB_LOCATION=/ s/^.*$//" \
        -e "/export IBUS_TABLE_LOCATION=/ s/^.*$//" \
        -i "engine/ibus-engine-table.in"
    sed -e "/export IBUS_TABLE_BIN_PATH=/ s/^.*$//" \
        -e "/export IBUS_TABLE_DATA_DIR=/ s/^.*$//" \
        -i "engine/ibus-table-createdb.in"
    sed -e "/export IBUS_PREFIX=/ s/^.*$//" \
        -e "/export IBUS_DATAROOTDIR=/ s/^.$//" \
        -e "/export IBUS_LOCALEDIR=/ s/^.$//" \
        -i "setup/ibus-setup-table.in"
  '';

  buildInputs = [
    dconf gtk3 gobjectIntrospection ibus python3 pygobject3
  ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "An IBus framework for table-based input methods";
    homepage     = https://github.com/kaio/ibus-table/wiki;
    license      = licenses.lgpl21;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ mudri ];
  };
}
