{stdenv, fetchgit, automake, autoconf, zlib, pciutils}:
let
  version = "0.5.1";
in
stdenv.mkDerivation {
  name = "biosdevname-${version}";
  
  src = fetchgit {
    url = git://linux.dell.com/biosdevname.git;
    rev = "refs/tags/v${version}";
    sha256 = "0qmgfyqv13qwh86140q0qdjxys76arg2d1slyvijx6r314ca4r7z";
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
