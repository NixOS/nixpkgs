{ composableDerivation, fetchurl, yacc, flex, texLive, libusb }:

let edf = composableDerivation.edf; in

composableDerivation.composableDerivation {} rec {
  name="avrdude-5.11";

  src = fetchurl {
    url = "mirror://savannah/avrdude/${name}.tar.gz";
    sha256 = "1mwmslqysak25a3x61pj97wygqgk79s5qpp50xzay6yb1zrz85v3";
  };

  configureFlags = [ "--disable-dependency-tracking" ];

  buildInputs = [ yacc flex libusb ];

  flags =
       edf { name = "doc"; enable = { buildInputs = texLive; configureFlags = ["--enable-doc"]; }; }
    // edf { name = "parport"; };

  cfg = {
    docSupport = false; # untested
    parportSupport = true;
  };

  meta = {
    license = "GPL-2";
    description = "AVR Downloader/UploaDEr";
    homepage = http://savannah.nongnu.org/projects/avrdude;
  };
}
