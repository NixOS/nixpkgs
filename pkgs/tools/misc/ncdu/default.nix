<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, ncurses
, zig_0_11
, installShellFiles
, pie ? stdenv.isDarwin
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncdu";
  version = "2.3";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdu-${finalAttrs.version}.tar.gz";
    hash = "sha256-u84dHHDxJHZxvk6iE12MUs0ppwivXtYs7Np9xqgACjw=";
  };

  nativeBuildInputs = [
    zig_0_11.hook
    installShellFiles
  ];

  buildInputs = [
    ncurses
  ];

  zigBuildFlags = lib.optional pie "-Dpie=true";

  postInstall = ''
    installManPage ncdu.1
  '';

  meta = {
    homepage = "https://dev.yorhel.nl/ncdu";
    description = "Disk usage analyzer with an ncurses interface";
    changelog = "https://dev.yorhel.nl/ncdu/changes2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pSub rodrgz ];
    inherit (zig_0_11.meta) platforms;
    mainProgram = "ncdu";
  };
})
=======
{ lib, stdenv, fetchurl, zig, ncurses }:

stdenv.mkDerivation rec {
  pname = "ncdu";
  version = "2.2.2";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    hash = "sha256-kNkgAk51Ixi0aXds5X4Ds8cC1JMprZglruqzbDur+ZM=";
  };

  XDG_CACHE_HOME="Cache"; # FIXME This should be set in stdenv

  nativeBuildInputs = [
    zig
  ];

  buildInputs = [ ncurses ];

  PREFIX = placeholder "out";

  # Avoid CPU feature impurity, see https://github.com/NixOS/nixpkgs/issues/169461
  ZIG_FLAGS = "-Drelease-safe -Dcpu=baseline";

  meta = with lib; {
    description = "Disk usage analyzer with an ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdu";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub SuperSandro2000 rodrgz ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
