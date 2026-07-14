{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "patchelf";
  version = "0.19.1-unstable-2026-07-06";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "7688b17c18d16f67fa8d5a82a2404c2e3a18648d";
    sha256 = "sha256-xQEdaa67TF5hysptlTPI3rcNMXoiROAjvQ35upMo5GU=";
  };

  # Drop test that fails on musl (?)
  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace tests/Makefile.am \
      --replace "set-rpath-library.sh" ""
  '';

  setupHook = [ ./setup-hook.sh ];

  nativeBuildInputs = [ autoreconfHook ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/NixOS/patchelf.git";
    };
  };

  meta = {
    homepage = "https://github.com/NixOS/patchelf";
    license = lib.licenses.gpl3;
    description = "Small utility to modify the dynamic linker and RPATH of ELF executables";
    mainProgram = "patchelf";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
