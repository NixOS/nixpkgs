{ stdenv, fetchFromGitHub }:
rec {
  version = "git-2018-06-07";

  src = fetchFromGitHub {
    owner = "IRATI";
    repo = "stack";
    rev = "9a280d8a1e49892331161f264720afc36619a9ab";
    sha256 = "1yb0g2msrrw5cad0nc5wh9fxaclskwfqcxl34cbi4iv6v52v2dr9";
  };

  prePatch = ''
    sed -i '/MAKEFLAGS=/d' Makefile.in
    sed -i 's|/bin/bash|${stdenv.shell}|g' configure kernel/configure
    sed -i '/AC_MSG_ERROR.*git/d' librina/configure.ac rina-tools/configure.ac rinad/configure.ac
    sed -i 's|-liporina|libiporina.la|g' rina-tools/src/rlite/Makefile.am
    sed -i "s|INSTALL_PREFIX=.*|INSTALL_PREFIX=\"$out\"|" kernel/configure
    sed -i 's|/var/run|/run|g' rina-tools/src/irati-ctl
  '';

  meta = with stdenv.lib; {
    description = "RINA implementation for Linux";
    homepage = https://github.com/IRATI/stack;
    license = licenses.gpl3;
    maintainers = with maintainers; [ rvl ];
    platforms = platforms.linux;
  };
}
