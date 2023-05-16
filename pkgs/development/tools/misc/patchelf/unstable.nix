{ lib, stdenv, fetchurl, autoreconfHook, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "patchelf";
<<<<<<< HEAD
  version = "unstable-2023-07-20";
=======
  version = "unstable-2023-04-25";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
<<<<<<< HEAD
    rev = "c40128936fc804b74abddaa0bc1d8ef6e5dba48e";
    sha256 = "sha256-qX0pGkHeX+KssiATwwohzUlGIZQqpIjKsLv32U2nyWA=";
=======
    rev = "008a582741617e2d7d5aa4aab1e8ddfdec0067d9";
    sha256 = "sha256-SC9zZbHN1p5BD6YHr+/ZNelmmZDozEO/vDwuCdJJCcs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Drop test that fails on musl (?)
  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace tests/Makefile.am \
      --replace "set-rpath-library.sh" ""
  '';

  setupHook = [ ./setup-hook.sh ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  doCheck = !stdenv.isDarwin;

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/NixOS/patchelf.git";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/NixOS/patchelf";
    license = licenses.gpl3;
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
