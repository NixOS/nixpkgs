{ lib, stdenv, fetchurl, fltk }:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdiskusage";
  version = "1.60";

  src = fetchurl {
    url = "https://xdiskusage.sourceforge.net/xdiskusage-${finalAttrs.version}.tgz";
    hash = "sha256-e1NtxvG9xtm+x8KblDXCPZ0yv/ig6+4muZZrJz3J9n4=";
  };

  nativeBuildInputs = [ fltk ];

  meta = {
    description = "Program to show you what is using up all your disk space";
    homepage = "https://xdiskusage.sourceforge.net/";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ fuzzdk ];
    platforms = with lib.platforms; linux;
  };
})
