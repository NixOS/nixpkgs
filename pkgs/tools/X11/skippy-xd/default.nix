{stdenv, fetchgit, xorgproto, libX11, libXft, libXcomposite, libXdamage
, libXext, libXinerama, libjpeg, giflib, pkgconfig
}:
let
  buildInputs = [
    xorgproto libX11 libXft libXcomposite libXdamage libXext
    libXinerama libjpeg giflib pkgconfig
  ];
in
stdenv.mkDerivation rec {
  version = "git-2015-03-01";
  name = "skippy-xd-${version}";
  inherit buildInputs;
  src = fetchgit {
    url = "https://github.com/richardgv/skippy-xd/";
    rev = "397216ca67";
    sha256 = "0zcjacilmsv69rv85j6nfr6pxy8z36w1sjz0dbjg6s5m4kga1zl8";
  };
  makeFlags = ["PREFIX=$(out)"];
  preInstall = ''
    sed -e "s@/etc/xdg@$out&@" -i Makefile
  '';
  meta = {
    inherit version;
    description = ''Expose-style compositing-based standalone window switcher'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
