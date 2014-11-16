{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "b43-fwcutter-018";

  src = fetchurl {
    url = "http://bues.ch/b43/fwcutter/${name}.tar.bz2";
    sha256 = "13v34pa0y1jf4hkhsh3zagyb7s8b8ymplffaayscwsd3s7f6kc2p";
  };

  patches = [ ./no-root-install.patch ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Firmware extractor for cards supported by the b43 kernel module";
    homepage = http://wireless.kernel.org/en/users/Drivers/b43;
    license = stdenv.lib.licenses.free;
  };
}
