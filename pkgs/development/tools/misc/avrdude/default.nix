args:
with args.lib; with args;
let
  co = chooseOptionsByFlags {
    inherit args;
    flagDescr = {
      mandatory ={ cfgOption = [ "--disable-dependency-tracking" ]; 
                   buildInputs=["yacc" "flex"]; };
      doc = { cfgOption = "--enable-doc"; buildInputs=["tetex"]; blocks=["doc" "because untested"]; }; #Enable building documents
      no_parport = { cfgOption = "--disable-parport"; }; #Enable accessing parallel ports(default)
    };
    #defaultFlags = ["doc"];
  };

in args.stdenv.mkDerivation {

  # passing the flags in case a library using this want's to check them (*) .. 
  inherit (co) /* flags */ buildInputs configureFlags;

  src = fetchurl {
      url = http://mirror.switch.ch/mirror/gentoo/distfiles/avrdude-5.4.tar.gz;
      sha256 = "bee4148c51ec95999d803cb9f68f12ac2e9128b06f07afe307d38966c0833b30";
    };

  name="avrdude-5.4";

  meta = {
    license = "GPL-2";
    description = "AVR Downloader/UploaDEr";
    homepage = http://savannah.nongnu.org/projects/avrdude;
  };
}
