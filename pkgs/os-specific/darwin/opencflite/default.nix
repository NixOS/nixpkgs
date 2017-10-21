{ stdenv, fetchurl, icu, libuuid, tzdata }:

stdenv.mkDerivation rec {
  name = "opencflite-${version}";
  version = "476.19.0";

  src = fetchurl {
    url = "mirror://sourceforge/opencflite/${name}.tar.gz";
    sha256 = "0jgmzs0ycl930hmzcvx0ykryik56704yw62w394q1q3xw5kkjn9v";
  };

  configureFlags = [ "--with-uuid=${libuuid}" ];
  buildInputs = [ icu tzdata.dev ];
  enableParallelBuilding = true;

  meta = {
    description = "Cross platform port of the macOS CoreFoundation";
    homepage = http://sourceforge.net/projects/opencflite/;
    license = stdenv.lib.licenses.apsl20;
  };
}
