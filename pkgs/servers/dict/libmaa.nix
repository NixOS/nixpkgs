{ stdenv, fetchurl, libtool }:

stdenv.mkDerivation rec {
  version = "1.3.2";
  name = "libmaa-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/dict/libmaa-${version}.tar.gz";
    sha256 = "1idi4c30pi79g5qfl7rr9s17krbjbg93bi8f2qrbsdlh78ga19ar";
  };

  buildInputs = [ libtool ];
  # configureFlags = [ "--datadir=/var/run/current-system/share/dictd" ];

  meta = with stdenv.lib; {
    description = "Dict protocol server and client";
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
