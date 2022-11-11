{ lib, stdenv, fetchurl, writeText
, xorgproto, libX11, libXext, libXrandr, libxcrypt
# default header can be obtained from
# https://git.suckless.org/slock/tree/config.def.h
, conf ? null }:

with lib;
stdenv.mkDerivation rec {
  pname = "slock";
  version = "1.4";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/slock-${version}.tar.gz";
    sha256 = "0sif752303dg33f14k6pgwq2jp1hjyhqv6x4sy3sj281qvdljf5m";
  };

  buildInputs = [ xorgproto libX11 libXext libXrandr libxcrypt ];

  installFlags = [ "PREFIX=$(out)" ];

  postPatch = "sed -i '/chmod u+s/d' Makefile";

  preBuild = optionalString (conf != null) ''
    cp ${writeText "config.def.h" conf} config.def.h
  '';

  makeFlags = [ "CC:=$(CC)" ];

  meta = {
    homepage = "https://tools.suckless.org/slock";
    description = "Simple X display locker";
    longDescription = ''
      Simple X display locker. This is the simplest X screen locker.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
  };
}
