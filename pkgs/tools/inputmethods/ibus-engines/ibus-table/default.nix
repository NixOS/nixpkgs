{ stdenv, fetchFromGitHub
, autoreconfHook, docbook2x, pkgconfig
, gtk3, dconf, gobjectIntrospection
, ibus, python3, pygobject3 }:

stdenv.mkDerivation rec {
  name = "ibus-table-${version}";
  version = "1.9.14";

  src = fetchFromGitHub {
    owner  = "kaio";
    repo   = "ibus-table";
    rev    = version;
    sha256 = "1mkx03iqrq5yq57y7hjqcmxfh41dsjykyyl70d41dflcgp5q2nhw";
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

  nativeBuildInputs = [ autoreconfHook docbook2x pkgconfig ];

  postUnpack = ''
    substituteInPlace $sourceRoot/engine/Makefile.am \
      --replace "docbook2man" "docbook2man --sgml"
  '';

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "An IBus framework for table-based input methods";
    homepage     = https://github.com/kaio/ibus-table/wiki;
    license      = licenses.lgpl21;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ mudri ];
  };
}
