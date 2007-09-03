args:
args.stdenv.mkDerivation {
  name = "uisp-20050207";

  configureFlags="--disable-dependency-tracking";

  src = args.fetchurl {
    url = http://mirror.switch.ch/mirror/gentoo/distfiles/uisp-20050207.tar.gz;
    sha256 = "1bncxp5yxh9r1yrp04vvhfiva8livi1pwic7v8xj99q09zrwahvw";
  };

  #buildInputs =(with args; []);

  meta = {
    description = "tool for AVR microcontrollers which can interface to many hardware in-system programmers";
    license = "GPL-2";
    homepage = http://savannah.nongnu.org/projects/uisp;
  };
}
