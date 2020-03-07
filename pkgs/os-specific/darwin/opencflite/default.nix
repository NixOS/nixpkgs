{ stdenv, fetchurl, icu, libuuid, tzdata }:

stdenv.mkDerivation rec {
  pname = "opencflite";
  version = "476.19.0";

  src = fetchurl {
    url = "mirror://sourceforge/opencflite/${pname}-${version}.tar.gz";
    sha256 = "0jgmzs0ycl930hmzcvx0ykryik56704yw62w394q1q3xw5kkjn9v";
  };

  configureFlags = [ "--with-uuid=${libuuid.dev}" ];
  buildInputs = [ icu tzdata.dev ];
  enableParallelBuilding = true;

  meta = {
    description = "Cross platform port of the macOS CoreFoundation";
    homepage = https://sourceforge.net/projects/opencflite/;
    license = stdenv.lib.licenses.apsl20;
  };
}
