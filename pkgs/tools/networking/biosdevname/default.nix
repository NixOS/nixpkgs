{ stdenv, fetchgit, autoreconfHook, zlib, pciutils }:

stdenv.mkDerivation rec {
  name = "biosdevname-${version}";
  version = "0.6.1";

  src = fetchgit {
    url = git://linux.dell.com/biosdevname.git;
    rev = "refs/tags/v${version}";
    sha256 = "059s3qyky9i497c9wnrjml15sknpsqbv01ww7q95bf9ybhdqqq8w";
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
