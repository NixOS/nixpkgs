{ stdenv, fetchurl, pam }:

stdenv.mkDerivation {
  name = "vlock-2.2.2";
  src = fetchurl
  {
    url = mirror://debian/pool/main/v/vlock/vlock_2.2.2.orig.tar.gz;
    sha256 = "1b9gv7hmlb8swda5bn40lp1yki8b8wv29vdnhcjqfl6ir98551za";
  };

  prePatch = ''
    sed -i -e '/INSTALL/ {
      s/-[og] [^ ]*//g; s/4711/755/
    }' Makefile modules/Makefile
  '';

  patches = [ ./eintr.patch ];

  configureFlags = "VLOCK_GROUP=root ROOT_GROUP=root";

  buildInputs = [ pam ];

  meta = with stdenv.lib; {
    description = "Virtual console locking program";
    license = licenses.gpl2;
    maintainers = [ maintainers.lethalman ];
    platforms = platforms.linux;
  };
}
