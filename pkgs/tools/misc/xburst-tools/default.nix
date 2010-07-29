{stdenv, fetchgit, libusb, autoconf, automake, confuse}:

let
  version = "2010-07-29";
in
stdenv.mkDerivation {
  name = "xburst-tools-${version}";

  patches = [ ./gcc-4.4.patch ];

  src = fetchgit {
    url = git://projects.qi-hardware.com/xburst-tools.git;
    rev = "00be212db22643ad602eaf60b30eb943f119e78d";
    sha256 = "66ea1a81b71bad599d76691f07a986f9bb2ccecf397e8486b661d8baace3460e";
  };

  preConfigure = ''
    sh autogen.sh
  '';

  buildInputs = [ libusb autoconf automake confuse ];

  meta = {
    description = "Qi tools to access the Ben Nanonote USB_BOOT mode";
    license = "GPLv3";
    homepage = http://www.linux-mtd.infradead.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
