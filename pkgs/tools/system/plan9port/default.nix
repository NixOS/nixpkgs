{stdenv, fetchurl, libX11, xproto, libXt, xextproto}:

stdenv.mkDerivation {
  name = "plan9port-20090318";
  
  builder = ./builder.sh;

  src = fetchurl {
    #url = http://swtch.com/plan9port/plan9port-20090318.tgz;
    url = file:///tmp/plan9port-20090318.tgz;
    sha256 = "1idb2l1s5j34sa1dj1wwnvj97z5z7cy73qjafrxf2bbda26axzqj";
  };

  buildInputs = [ libX11 xproto libXt xextproto ];

  meta = {
    homepage = "http://swtch.com/plan9port/";
    description = "Plan 9 from User Space";
    license="free";
  };
}
