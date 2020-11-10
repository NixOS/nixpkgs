{ stdenv, lib, fetchFromGitHub, meson, ninja, pkgconfig, libseccomp }:

stdenv.mkDerivation rec {
  name = "unstick";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kwohlfahrt";
    repo = name;
    rev = "effee9aa242ca12dc94cc6e96bc073f4cc9e8657";
    sha256 = "08la3jmmzlf4pm48bf9zx4cqj9gbqalpqy0s57bh5vfsdk74nnhv";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ libseccomp ];

  meta = {
    homepage = "https://github.com/kwohlfahrt/unstick";
    description = "Silently eats chmod commands forbidden by Nix";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ kwohlfahrt ];
  };
}
