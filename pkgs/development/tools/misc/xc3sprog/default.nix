{ stdenv, fetchsvn, cmake, libusb, libftdi }:

# The xc3sprog project doesn't seem to make proper releases, they only put out
# prebuilt binary subversion snapshots on sourceforge.

stdenv.mkDerivation rec {
  version = "787";
  pname = "xc3sprog";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/xc3sprog/code/trunk";
    sha256 = "1rfhms3i7375kdlg0sdg5k52ix3xv5llj2dr30vamyg7pk74y8rx";
    rev = version;
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
