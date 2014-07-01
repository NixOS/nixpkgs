{ stdenv, fetchurl, gnumake, file }:

stdenv.mkDerivation rec {
  name = "keyutils-1.5.9";
  
  src = fetchurl {
    url = "http://people.redhat.com/dhowells/keyutils/${name}.tar.bz2";
    sha256 = "1bl3w03ygxhc0hz69klfdlwqn33jvzxl1zfl2jmnb2v85iawb8jd";
  };

  buildInputs = [ file ];

  patchPhase = ''
    sed -i -e "s, /usr/bin/make, ${gnumake}/bin/make," \
        -e "s, /usr, ," \
        -e "s,\$(LNS) \$(LIBDIR)/\$(SONAME),\$(LNS) \$(SONAME)," \
        Makefile
  '';

  installPhase = "make install DESTDIR=$out";
  
  meta = with stdenv.lib; {
    homepage = http://people.redhat.com/dhowells/keyutils/;
    description = "Tools used to control the Linux kernel key management system";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
