{ composableDerivation, fetchurl, yacc, flex, texLive }:

let edf = composableDerivation.edf; in

composableDerivation.composableDerivation {} rec {
  name="avrdude-5.10";

  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/avrdude/${name}.tar.gz";
    sha256 = "0pmy73777x8p7f2aj2w2q1dnk1bvhd1cm7hcs1s9hsdqsmiinl41";
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
