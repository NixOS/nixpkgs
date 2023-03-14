{ lib, stdenv, fetchurl, writeText
, xorgproto, libX11, libXext, libXrandr, libxcrypt
# default header can be obtained from
# https://git.suckless.org/slock/tree/config.def.h
, conf ? null }:

stdenv.mkDerivation (finalAttrs: {
  pname = "slock";
  version = "1.5";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/slock-${finalAttrs.version}.tar.gz";
    hash = "sha256-ruHj+/aid/tiWjg4BzuXm2SD57rKTOgvVt4f8ZLbDk0=";
  };

  buildInputs = [ xorgproto libX11 libXext libXrandr libxcrypt ];

  installFlags = [ "PREFIX=$(out)" ];

  postPatch = "sed -i '/chmod u+s/d' Makefile";

  preBuild = lib.optionalString (conf != null) ''
    cp ${writeText "config.def.h" conf} config.def.h
  '';

  makeFlags = [ "CC:=$(CC)" ];

  meta = with lib; {
    homepage = "https://tools.suckless.org/slock";
    description = "Simple X display locker";
    longDescription = ''
      Simple X display locker. This is the simplest X screen locker.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
  };
})
