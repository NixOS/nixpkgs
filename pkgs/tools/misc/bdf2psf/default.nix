{ stdenv, fetchurl, perl, dpkg }:

stdenv.mkDerivation rec {
  name = "bdf2psf-${version}";
  version = "1.134";

  src = fetchurl {
    url = "mirror://debian/pool/main/c/console-setup/bdf2psf_${version}_all.deb";
    sha256 = "1am5ka5qrbh60jjihzqac03ii3ydprvqm3w54dc55a0zwl61njsz";
  };

  buildInputs = [ dpkg ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = "dpkg-deb -x $src .";
  installPhase = "
    substituteInPlace usr/bin/bdf2psf --replace /usr/bin/perl ${perl}/bin/perl
    mv usr/bin .
    cp -r . $out
  ";

  meta = with stdenv.lib; {
    description = "BDF to PSF converter";
    homepage = https://packages.debian.org/sid/bdf2psf;
    longDescription = ''
      Font converter to generate console fonts from BDF source fonts
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
  };
}
