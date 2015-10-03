{ stdenv, fetchurl, ibus, pkgconfig, python3, pythonPackages }:

stdenv.mkDerivation rec {
  name = "ibus-table-${version}";
  version = "1.9.6";

  src = fetchurl {
    url = "https://github.com/kaio/ibus-table/releases/download/${version}/${name}.tar.gz";
    sha256 = "0xygfscmsx0x80c4d4v40k9bc7831kgdsc74mc84ljxbjg9p9lcf";
  };

  buildInputs = [ ibus pkgconfig python3 pythonPackages.pygobject3 ];

  meta = with stdenv.lib; {
    description = "An IBus framework for table-based input methods";
    homepage    = https://github.com/kaio/ibus-table/wiki;
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ mudri ];
  };
}
