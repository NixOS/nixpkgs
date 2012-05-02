{ stdenv, fetchurl, xproto, libX11, libXext }:
stdenv.mkDerivation rec {
  name = "slock-1.0";
  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "b4e44ff1660f6f7eb270a0575d6ae1e0fbffcf0cdd96860a1695d57e89ae2df9";
  };
  buildInputs = [ xproto libX11 libXext	];
  installFlags = "DESTDIR=\${out} PREFIX=";
  meta = {
    homepage = http://tools.suckless.org/slock;
    description = "Simple X display locker";
    longDescription = ''
      Simple X display locker. This is the simplest X screen locker.
    '';
    license = "bsd";
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
