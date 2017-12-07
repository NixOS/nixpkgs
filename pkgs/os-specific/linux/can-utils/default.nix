{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "can-utils-${version}";
  # There are no releases (source archives or git tags), so use the date of the
  # latest commit in git master as version number.
  version = "20140227";

  src = fetchFromGitHub {
    owner = "linux-can";
    repo = "can-utils";
    rev = "67a2bdcd336e6becfa5784742e18c88dbeddc973";
    sha256 = "1v73b0nk1kb3kp5nbxp4xiygny6nfjgjnm7zgzrjgryvdrnws32z";
  };

  preConfigure = ''makeFlagsArray+=(PREFIX="$out")'';

  meta = with stdenv.lib; {
    description = "CAN userspace utilities and tools (for use with Linux SocketCAN)";
    homepage = https://github.com/linux-can/can-utils;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
