{ lib, stdenv, fetchurl, intltool, pkg-config, glib }:

stdenv.mkDerivation rec {
  pname = "gnu-mdk";
  version = "1.3.0";
  src = fetchurl {
    url = "mirror://gnu/gnu/mdk/v${version}/mdk-${version}.tar.gz";
    sha256 = "0bhk3c82kyp8167h71vdpbcr852h5blpnwggcswqqwvvykbms7lb";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ intltool glib ];
  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp -v ./misc/*.el $out/share/emacs/site-lisp
  '';

  meta = {
    description = "GNU MIX Development Kit (MDK)";
    homepage = "https://www.gnu.org/software/mdk/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}
