{ stdenv, lib, fetchurl, writeText
, xproto, libX11, libXext, libXrandr
# default header can be obtained from
# http://git.suckless.org/slock/tree/config.def.h
, conf ? null }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "slock-1.4";

  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "0sif752303dg33f14k6pgwq2jp1hjyhqv6x4sy3sj281qvdljf5m";
  };

  buildInputs = [ xproto libX11 libXext libXrandr ];

  installFlags = "DESTDIR=\${out} PREFIX=";

  patchPhase = "sed -i '/chmod u+s/d' Makefile";

  preBuild = optionalString (conf != null) ''
    cp ${writeText "config.def.h" conf} config.def.h
  '';

  meta = {
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
