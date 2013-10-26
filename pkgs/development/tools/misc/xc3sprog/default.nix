{ stdenv, fetchsvn, cmake, libusb, libftdi }:

# The xc3sprog project doesn't seem to make proper releases, they only put out
# prebuilt binary subversion snapshots on sourceforge.

stdenv.mkDerivation rec {
  version = "748"; # latest @ 2013-10-26
  name = "xc3sprog-${version}";

  src = fetchsvn rec {
    url = "https://svn.code.sf.net/p/xc3sprog/code/trunk";
    sha256 = "0wkz6094kkqz91qpa24pzlbhndc47sjmqhwk3p7ccabv0041rzk0";
    rev = "${version}";
  };

  buildInputs = [ cmake libusb libftdi ];

  meta = with stdenv.lib; {
    description = "Command-line tools for programming FPGAs, microcontrollers and PROMs via JTAG";
    homepage = http://xc3sprog.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
