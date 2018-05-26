{ stdenv, fetchurl, fetchpatch, python3, which }:

stdenv.mkDerivation rec {
  name = "fatrace-${version}";
  version = "0.13";

  src = fetchurl {
    url = "http://launchpad.net/fatrace/trunk/${version}/+download/${name}.tar.bz2";
    sha256 = "0hrh45bpzncw0jkxw3x2smh748r65k2yxvfai466043bi5q0d2vx";
  };

  buildInputs = [ python3 which ];

  postPatch = ''
    substituteInPlace power-usage-report \
      --replace "'which'" "'${which}/bin/which'"

    # Avoid a glibc >= 2.25 deprecation warning that gets fatal via -Werror.
    sed 1i'#include <sys/sysmacros.h>' -i fatrace.c
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Report system-wide file access events";
    homepage = https://launchpad.net/fatrace/;
    license = licenses.gpl3Plus;
    longDescription = ''
      fatrace reports file access events from all running processes.
      Its main purpose is to find processes which keep waking up the disk
      unnecessarily and thus prevent some power saving.
      Requires a Linux kernel with the FANOTIFY configuration option enabled.
      Enabling X86_MSR is also recommended for power-usage-report on x86.
    '';
    platforms = platforms.linux;
  };
}
