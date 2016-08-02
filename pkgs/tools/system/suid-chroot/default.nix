{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "suid-chroot-${version}";
  version = "1.0.2";

  src = fetchurl {
    sha256 = "1a9xqhck0ikn8kfjk338h9v1yjn113gd83q0c50k78xa68xrnxjx";
    url = "http://myweb.tiscali.co.uk/scottrix/linux/download/${name}.tar.bz2";
  };

  postPatch = ''
    substituteInPlace Makefile --replace /usr $out
  '';

  meta = with stdenv.lib; {
    description = "Setuid-safe wrapper for chroot";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nckx ];
    platforms = with platforms; unix;
  };
}
