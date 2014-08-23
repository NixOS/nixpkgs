{ stdenv, fetchurl, xproto, libX11, libXext }:
stdenv.mkDerivation rec {
  name = "slock-1.1";
  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "1r70s3npmp0nyrfdsxz8cw1i1z8n9phqdlw02wjphv341h3yajp0";
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
