{ stdenv, fetchFromGitHub }:
rec {
  version = "git-2018-04-23";

  src = fetchFromGitHub {
    owner = "IRATI";
    repo = "stack";
    rev = "4a5ba0df45d877cea4a82d8b3ed6c526c0f25d98";
    sha256 = "1jgf6fybdbk0xhy9kbgiv5mjpjpd8bdmc316i6mybmrl34x736bn";
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
