{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "patchelf";
  version = "0.19.3-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "2b4b49d36b62690860414dd127f567be4f1f3208";
    hash = "sha256-jeHuH5wi8yEs148ApY636xkVhp4jT5tRZHTluW4AQtY=";
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
