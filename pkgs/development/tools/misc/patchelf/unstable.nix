{ lib, stdenv, autoreconfHook, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "patchelf";
  version = "0.18.0-unstable-2025-01-08";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "739a486eced6c09e4c705f92fd6353e8f7f833c0";
    sha256 = "sha256-DVi0PxB9bVYpU/3n+4WnryJcVTirOrUf/fXlhV6u4Gc=";
  };

  # Drop test that fails on musl (?)
  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace tests/Makefile.am \
      --replace "set-rpath-library.sh" ""
  '';

  setupHook = [ ./setup-hook.sh ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/NixOS/patchelf.git";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/NixOS/patchelf";
    license = licenses.gpl3;
    description = "Small utility to modify the dynamic linker and RPATH of ELF executables";
    mainProgram = "patchelf";
    maintainers = [ ];
    platforms = platforms.all;
  };
}
