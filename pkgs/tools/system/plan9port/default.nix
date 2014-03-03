{stdenv, fetchurl, libX11, xproto, libXt, xextproto, libXext}:

stdenv.mkDerivation rec {
  name = "plan9port-20140228";
  
  builder = ./builder.sh;

  src = fetchurl {
    url = "http://swtch.com/plan9port/${name}.tgz";
    sha256 = "1l7nsjfrrcq0l43kw0f1437jz3nyl9qw7i2vn0sbmcsv5vmsj0cr";
  };

  buildInputs = [ libX11 xproto libXt xextproto libXext ];

  meta = {
    homepage = "http://swtch.com/plan9port/";
    description = "Plan 9 from User Space";
    license="free";
  };
}
