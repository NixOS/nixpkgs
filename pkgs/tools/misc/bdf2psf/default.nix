{ stdenv, fetchurl, perl, dpkg }:

stdenv.mkDerivation rec {
  pname = "bdf2psf";
  version = "1.193";

  src = fetchurl {
    url = "mirror://debian/pool/main/c/console-setup/bdf2psf_${version}_all.deb";
    sha256 = "1mykng02fyxshm02kywrk16f27b1jhgn9zcaxcvxd255sn58w68k";
  };

  buildInputs = [ dpkg ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = "dpkg-deb -x $src .";
  installPhase = "
    substituteInPlace usr/bin/bdf2psf --replace /usr/bin/perl ${perl}/bin/perl
    mv usr $out
  ";

  meta = with stdenv.lib; {
    description = "BDF to PSF converter";
    homepage = https://packages.debian.org/sid/bdf2psf;
    longDescription = ''
      Font converter to generate console fonts from BDF source fonts
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj vrthra ];
    platforms = platforms.unix;
  };
}
