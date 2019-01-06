{ stdenv, gnu-efi, sbsigntool, openssl, perl, perlPackages, help2man, fetchgit}:

stdenv.mkDerivation {
  name = "efitools";
  buildInputs = [ gnu-efi sbsigntool openssl perl perlPackages.FileSlurp help2man];

  preConfigure = ''
    sed -i 's@-I/usr/include/efi@-I${gnu-efi}/include/efi@g' Make.rules
    sed -i 's@^CRTPATHS\s*=.*$@CRTPATHS=${gnu-efi}/lib@' Make.rules
    sed -i "s@\$(DESTDIR)/usr@$out@" Make.rules
    sed -i "s@\$(DESTDIR)/usr@$out@" Make.rules
    sed -i 's,#!/usr/bin/env perl,#!${perl}/bin/perl,g' xxdi.pl
  '';

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/linux/kernel/git/jejb/efitools.git;
    rev = "v1.8.1";
    sha256 = "1ssx0bw5adb8ja5hszkbi1c9v9hgzhhnwcysbv9g9lgr70459gz6";
  };
  
  meta = with stdenv.lib; {
    description = "Useful tools for manipulating UEFI secure boot platforms";
    homepage = https://git.kernel.org/pub/scm/linux/kernel/git/jejb/efitools.git/about/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ redfish64 ];
    platforms = platforms.linux;
  };
}
