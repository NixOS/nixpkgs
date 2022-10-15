{ lib, stdenv, fetchurl, perl, dpkg }:

stdenv.mkDerivation rec {
  pname = "bdf2psf";
  version = "1.210";

  src = fetchurl {
    url = "mirror://debian/pool/main/c/console-setup/bdf2psf_${version}_all.deb";
    sha256 = "sha256-7kHUwKQoNCHphZiUs3jwYeosiL5Kxp3rimOJX8PmwJk=";
  };

  nativeBuildInputs = [ dpkg ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';
  installPhase = "
    runHook preInstall
    substituteInPlace usr/bin/bdf2psf --replace /usr/bin/perl ${perl}/bin/perl
    mv usr $out
    runHook postInstall
  ";

  meta = with lib; {
    description = "BDF to PSF converter";
    homepage = "https://packages.debian.org/sid/bdf2psf";
    longDescription = ''
      Font converter to generate console fonts from BDF source fonts
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ rnhmjoj vrthra ];
    platforms = platforms.unix;
  };
}
