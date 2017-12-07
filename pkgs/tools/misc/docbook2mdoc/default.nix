{ stdenv, fetchurl, expat }:

stdenv.mkDerivation rec {
  name = "docbook2mdoc-${version}";
  version = "0.0.9";

  src = fetchurl {
    url = "http://mdocml.bsd.lv/docbook2mdoc/snapshots/${name}.tgz";
    sha256 = "07il80sg89xf6ym4bry6hxdacfzqgbwkxzyf7bjaihmw5jj0lclk";
  };

  buildInputs = [ expat.dev ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://mdocml.bsd.lv/;
    description = "converter from DocBook V4.x and v5.x XML into mdoc";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ ramkromberg ];
  };
}
