{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "can-utils-${version}";
  # There are no releases (source archives or git tags), so use the date of the
  # latest commit in git master as version number.
  version = "20140227";

  src = fetchgit {
    url = "https://git.gitorious.org/linux-can/can-utils.git";
    rev = "67a2bdcd336e6becfa5784742e18c88dbeddc973";
    sha256 = "0pnnjl141wf3kbf256m6qz9mxz0144z36qqb43skialzcnlhga38";
  };

  preConfigure = ''makeFlagsArray+=(PREFIX="$out")'';

  meta = with stdenv.lib; {
    description = "CAN userspace utilities and tools (for use with Linux SocketCAN)";
    homepage = "https://gitorious.org/linux-can/can-utils";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
