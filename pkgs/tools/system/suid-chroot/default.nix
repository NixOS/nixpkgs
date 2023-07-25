{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "suid-chroot";
  version = "1.0.2";

  src = fetchurl {
    sha256 = "1a9xqhck0ikn8kfjk338h9v1yjn113gd83q0c50k78xa68xrnxjx";
    url = "http://myweb.tiscali.co.uk/scottrix/linux/download/${pname}-${version}.tar.bz2";
  };

  postPatch = ''
    substituteInPlace Makefile --replace /usr $out
    sed -i -e '/chmod u+s/d' Makefile
  '';

  meta = with lib; {
    description = "Setuid-safe wrapper for chroot";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
  };
}
