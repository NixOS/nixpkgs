{ stdenv, fetchgit, autoreconfHook, zlib, pciutils }:

stdenv.mkDerivation rec {
  name = "biosdevname-${version}";
  version = "0.6.1";

  src = fetchgit {
    url = git://linux.dell.com/biosdevname.git;
    rev = "refs/tags/v${version}";
    sha256 = "11g2pziss0i65mr4y3mwjlcdgpygaxa06lr4q8plmrwl9cick1qa";
  };

  buildInputs = [
    autoreconfHook
    zlib
    pciutils
  ];

  # Don't install /lib/udev/rules.d/*-biosdevname.rules
  patches = [ ./makefile.patch ];

  configureFlags = [ "--sbindir=\${out}/bin" ];

  meta = with stdenv.lib; {
    description = "Udev helper for naming devices per BIOS names";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
