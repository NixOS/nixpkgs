{stdenv, fetchurl, wxPython}:

assert wxPython.python.zlibSupport;

stdenv.mkDerivation {
  name = "bittorrent-3.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://bitconjurer.org/BitTorrent/BitTorrent-3.3.tar.gz;
    md5 = "1ecf1fc40b4972470313f9ae728206e8";
  };
  python = wxPython.python;
  inherit wxPython;
}
