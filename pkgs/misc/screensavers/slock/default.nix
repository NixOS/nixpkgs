{ stdenv, fetchurl, xproto, libX11, libXext, libXrandr }:
stdenv.mkDerivation rec {
  name = "slock-1.4";
  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "0sif752303dg33f14k6pgwq2jp1hjyhqv6x4sy3sj281qvdljf5m";
  };
  buildInputs = [ xproto libX11 libXext libXrandr ];
  installFlags = "DESTDIR=\${out} PREFIX=";
  meta = with stdenv.lib; {
    homepage = http://tools.suckless.org/slock;
    description = "Simple X display locker";
    longDescription = ''
      Simple X display locker. This is the simplest X screen locker.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
  };
}
