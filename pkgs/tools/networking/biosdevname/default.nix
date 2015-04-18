{stdenv, fetchgit, automake, autoconf, zlib, pciutils}:
let
  version = "0.6.1";
in
stdenv.mkDerivation {
  name = "biosdevname-${version}";
  
  src = fetchgit {
    url = git://linux.dell.com/biosdevname.git;
    rev = "refs/tags/v${version}";
    sha256 = "11g2pziss0i65mr4y3mwjlcdgpygaxa06lr4q8plmrwl9cick1qa";
  };

  buildInputs = [
    automake
    autoconf
    zlib
    pciutils
  ];

  preConfigure = ''
    autoreconf -i
  '';

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
