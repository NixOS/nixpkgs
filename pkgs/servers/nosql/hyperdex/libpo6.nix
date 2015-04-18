{ stdenv, fetchurl, unzip, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "libpo6-${version}";
  version = "0.5.2";

  src = fetchurl {
    url = "https://github.com/rescrv/po6/archive/releases/${version}.zip";
    sha256 = "14g3ichshnc4wd0iq3q3ymgaq84gjsbqcyn6lri7c7djgkhqijjx";
  };
  buildInputs = [ unzip autoconf automake libtool ];
  preConfigure = "autoreconf -i";

  meta = with stdenv.lib; {
    description = "POSIX wrappers for C++";
    homepage = https://github.com/rescrv/po6;
    license = licenses.bsd3;
  };
}
