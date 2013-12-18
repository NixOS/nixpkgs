{ composableDerivation, fetchurl, yacc, flex, texLive, libusb }:

let edf = composableDerivation.edf; in

composableDerivation.composableDerivation {} rec {
  name="avrdude-6.0.1";

  src = fetchurl {
    url = "mirror://savannah/avrdude/${name}.tar.gz";
    sha256 = "0hfy1qkc6a5vpqsp9ahi1fpf9x4s10wq4bpyblc26sx9vxl4d066";
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
