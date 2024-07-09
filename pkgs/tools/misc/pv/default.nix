{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pv";
  version = "1.8.10";

  src = fetchurl {
    url = "https://www.ivarch.com/programs/sources/pv-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-1MkMF8/NRKqWuYI3cx5PgR4HHUwgUqaJ0tgeZnH1cbE=";
  };

  meta = {
    homepage = "https://www.ivarch.com/programs/pv.shtml";
    description = "Tool for monitoring the progress of data through a pipeline";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.all;
    mainProgram = "pv";
  };
})
