{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "can-utils";
  # There are no releases (source archives or git tags), so use the date of the
  # latest commit in git master as version number.
  version = "20170830";

  src = fetchFromGitHub {
    owner = "linux-can";
    repo = "can-utils";
    rev = "5b518a0a5fa56856f804372a6b99b518dedb5386";
    sha256 = "1ygzp8rjr8f1gs48mb1pz7psdgbfhlvr6kjdnmzbsqcml06zvrpr";
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
