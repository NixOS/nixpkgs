{ composableDerivation, fetchurl, yacc, flex, texLive }:

let edf = composableDerivation.edf; in

composableDerivation.composableDerivation {} {
  name="avrdude-5.4";

  src = fetchurl {
    url = http://mirror.switch.ch/mirror/gentoo/distfiles/avrdude-5.4.tar.gz;
    sha256 = "bee4148c51ec95999d803cb9f68f12ac2e9128b06f07afe307d38966c0833b30";
  };

  configureFlags = [ "--disable-dependency-tracking" ];

  buildInputs = [ yacc flex ];

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
