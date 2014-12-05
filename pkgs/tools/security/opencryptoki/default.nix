{ stdenv, fetchurl, openssl, trousers, automake, autoconf, libtool, bison, flex }:

stdenv.mkDerivation rec {
  version = "3.2";
  name = "opencryptoki-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/opencryptoki/opencryptoki/v${version}/opencryptoki-v${version}.tgz";
    sha256 = "06r6zp299vxdspl6k65myzgjv0bihg7kc500v7s4jd3mcrkngd6h";
  };

  buildInputs = [ automake autoconf libtool openssl trousers bison flex ];

  preConfigure = ''
    substituteInPlace configure.in --replace "chown" "true"
    substituteInPlace configure.in --replace "chgrp" "true"
    sh bootstrap.sh --prefix=$out
  '';

  configureFlags = [ "--disable-ccatok" "--disable-icatok" ];

  makeFlags = "DESTDIR=$(out)";

  # work around the build script of opencryptoki
  postInstall = ''
    cp -r $out/$out/* $out
    rm -r $out/nix
    '';

  meta = with stdenv.lib; {
    description = "PKCS#11 implementation for Linux";
    homepage    = http://opencryptoki.sourceforge.net/;
    license     = licenses.cpl10;
    maintainers = [ maintainers.tstrobel ];
    platforms   = platforms.unix;
  };
}

