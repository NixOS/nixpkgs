{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "patchelf";
  version = "0.18.0-unstable-2025-08-13";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "b49de1b3384e7928bf0df9a889fe5a4e7b3fbddf";
    sha256 = "sha256-0AGK+ZPZDc7zTVAmG6jAAynQhh4nP8skVwOEV5hZKh0=";
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
