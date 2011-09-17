{ stdenv, fetchurl, xproto, libX11, libXext }:
stdenv.mkDerivation rec {
  name = "slock-0.9";
  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "1gfp2ic2i63yz8wrf5cqzv9g422j9qs249y7g4chq0brpcybgpc9";
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
