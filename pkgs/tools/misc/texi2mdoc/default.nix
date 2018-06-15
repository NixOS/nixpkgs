{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "texi2mdoc-${version}";
  version = "0.1.2";

  src = fetchurl {
    url = "http://mdocml.bsd.lv/texi2mdoc/snapshots/${name}.tgz";
    sha256 = "1zjb61ymwfkw6z5g0aqmsn6qpw895zdxv7fv3059gj3wqa3zsibs";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://mdocml.bsd.lv/;
    description = "converter from Texinfo into mdoc";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ ramkromberg ];
  };
}
