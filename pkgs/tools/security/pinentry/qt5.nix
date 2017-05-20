{ fetchurl, stdenv, pkgconfig
, libgpgerror, libassuan
, qtbase
, libcap ? null
}:

let
  mkFlag = pfxTrue: pfxFalse: cond: name: "--${if cond then pfxTrue else pfxFalse}-${name}";
  mkEnable = mkFlag "enable" "disable";
  mkWith = mkFlag "with" "without";
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "pinentry-0.9.6";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${name}.tar.bz2";
    sha256 = "0rhyw1vk28kgasjp22myf7m2q8kycw82d65pr9kgh93z17lj849a";
  };

  buildInputs = [ libgpgerror libassuan libcap qtbase ];

  # configure cannot find moc on its own
  preConfigure = ''
    export QTDIR="${qtbase.dev}"
    export MOC="${qtbase.dev}/bin/moc"
  '';

  configureFlags = [
    (mkWith   (libcap != null)  "libcap")
    (mkEnable true "pinentry-qt")
  ];

  NIX_CFLAGS_COMPILE = [ "-std=c++11" ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = "http://gnupg.org/aegypten2/";
    description = "GnuPG's interface to passphrase input";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
    longDescription = ''
      Pinentry provides a console and (optional) GTK+ and Qt GUIs allowing users
      to enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
  };
}
