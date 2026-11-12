{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "patchelf";
  version = "0.19.2-unstable-2026-10-20";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "3e996dbef1fa0658012f8dd290bddcf0302acade";
    hash = "sha256-+c7LIYKu0pYnG7h1dsEIDs6l4+91Vh/oDrSDARdBK3o=";
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
