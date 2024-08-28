{ lib, stdenv, autoreconfHook, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "patchelf";
  version = "0.18.0-unstable-2024-06-15";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "a0f54334df36770b335c051e540ba40afcbf8378";
    sha256 = "sha256-FSoxTcRZMGHNJh8dNtKOkcUtjhmhU6yQXcZZfUPLhQM=";
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
    description = "Small utility to modify the dynamic linker and RPATH of ELF executables";
    mainProgram = "patchelf";
    maintainers = [ ];
    platforms = platforms.all;
  };
}
