{ stdenv, lib, fetchFromGitHub, coreutils, pamSupport ? "yes", pam , bison, sudo, utillinux }:

stdenv.mkDerivation rec {
  name = "opendoas-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Duncaen";
    repo = "OpenDoas";
    rev = "v${version}";
    sha256 = "1m3w6ky9pq79ha53fnz8fzc2758wnh2s5dcm6dcm0vj7lrr5a65b";
  };

  buildInputs = [ coreutils bison utillinux ] ++ lib.optionals (pamSupport != null) [ pam ];

  makeFlags = [
    "BINOWN="
    "BINGRP="
    "DESTDIR="
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/share/man"
    "PAMDIR=$(out)/etc"
  ];

  configurePhase = "./configure --prefix=$out " + lib.optionalString (pamSupport == null) "--without-pam";

  enableParallelBuilding = true;

  postPatch = ''
    grep -lr '/s\?bin/' | xargs sed -i \
      -e 's|/bin/mount|${utillinux}/bin/mount|' \
      -e 's|/bin/umount|${utillinux}/bin/umount|' \
      -e 's|/bin/cp|${coreutils}/bin/cp|' \
      -e 's|/bin/mv|${coreutils}/bin/mv|' \
      -e 's|/bin/chown|${coreutils}/bin/chown|' \
      -e 's|/bin/date|${coreutils}/bin/date|' \
      -e 's|/usr/bin/sudo|/var/setuid-wrappers/sudo|'
  '';


  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A command to run commands as root";
    license = licenses.bsd2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
