{ lib, stdenv, fetchFromGitHub, pcre-cpp, sqlite, ncurses
, readline, zlib, bzip2, autoconf, automake, curl }:

stdenv.mkDerivation rec {
  pname = "lnav";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "tstack";
    repo = "lnav";
    rev = "v${version}";
    sha256 = "sha256-1b4mVKIUotMSK/ADHnpiM42G98JF0abL8sXXGFyS3sw=";
  };

  patches = [ ./0001-Forcefully-disable-docs-build.patch ];
  postPatch = ''
    substituteInPlace Makefile.am \
      --replace "SUBDIRS = src test" "SUBDIRS = src"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [
    zlib
    bzip2
    ncurses
    pcre-cpp
    readline
    sqlite
    curl
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/tstack/lnav";
    description = "The Logfile Navigator";
    longDescription = ''
      The log file navigator, lnav, is an enhanced log file viewer that takes
      advantage of any semantic information that can be gleaned from the files
      being viewed, such as timestamps and log levels. Using this extra
      semantic information, lnav can do things like interleaving messages from
      different files, generate histograms of messages over time, and providing
      hotkeys for navigating through the file. It is hoped that these features
      will allow the user to quickly and efficiently zero in on problems.
    '';
    downloadPage = "https://github.com/tstack/lnav/releases";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dochang ma27 ];
    platforms = platforms.unix;
  };

}
