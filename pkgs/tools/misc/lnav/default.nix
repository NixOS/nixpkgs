{ lib
, stdenv
, fetchFromGitHub
, pcre2
, sqlite
, ncurses
, readline
, zlib
, bzip2
, autoconf
, automake
, curl
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "lnav";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "tstack";
    repo = "lnav";
    rev = "v${version}";
    sha256 = "sha256-OuxxcXpdpSxrDdiUqRbEaXvCZBAcWvE4YwaMtLKSqCM=";
  };

  patches = [ ./0001-Forcefully-disable-docs-build.patch ];
  postPatch = ''
    substituteInPlace Makefile.am \
      --replace "SUBDIRS = tools src test" "SUBDIRS = tools src"
  '';

  enableParallelBuilding = true;

  strictDeps = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoconf
    automake
    zlib
    curl.dev
  ];
  buildInputs = [
    bzip2
    ncurses
    pcre2
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
    maintainers = with maintainers; [ dochang ];
    platforms = platforms.unix;
    mainProgram = "lnav";
  };

}
