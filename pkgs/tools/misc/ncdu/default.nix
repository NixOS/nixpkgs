{ lib
, stdenv
, fetchurl
, ncurses
, zig_0_10
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncdu";
  version = "2.2.2";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdu-${finalAttrs.version}.tar.gz";
    hash = "sha256-kNkgAk51Ixi0aXds5X4Ds8cC1JMprZglruqzbDur+ZM=";
  };

  nativeBuildInputs = [
    zig_0_10.hook
  ];

  buildInputs = [
    ncurses
  ];

  meta = {
    homepage = "https://dev.yorhel.nl/ncdu";
    description = "Disk usage analyzer with an ncurses interface";
    changelog = "https://dev.yorhel.nl/ncdu/changes2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pSub rodrgz ];
    inherit (zig_0_10.meta) platforms;
  };
})
