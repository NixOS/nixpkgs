{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "patchelf";
  version = "0.19.2-unstable-2026-10-01";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "382d8bc12db9e720515da49d9c272ef4a622c3c0";
    hash = "sha256-OSTKbYkHY0bNnzVkURzCQXActiV+67kCbs3ecETN31s=";
  };

  # Drop test that fails on musl (?)
  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace tests/Makefile.am \
      --replace "set-rpath-library.sh" ""
  '';

  setupHook = [ ./setup-hook.sh ];

  nativeBuildInputs = [ autoreconfHook ];

  strictDeps = true;

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/NixOS/patchelf.git";
    };
  };

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/NixOS/patchelf";
    license = lib.licenses.gpl3;
    description = "Small utility to modify the dynamic linker and RPATH of ELF executables";
    mainProgram = "patchelf";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
