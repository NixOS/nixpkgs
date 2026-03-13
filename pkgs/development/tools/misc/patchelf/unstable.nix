{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "patchelf";
  version = "0.18.0-unstable-2025-11-11";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "d0f70eea5397606c486857e0a105e53ec123904a";
    sha256 = "sha256-CWAlYVtcswIpOZj5Qyxswsy1pAnPUTTUDapJO9ar0Mc=";
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

  meta = {
    homepage = "https://github.com/NixOS/patchelf";
    license = lib.licenses.gpl3;
    description = "Small utility to modify the dynamic linker and RPATH of ELF executables";
    mainProgram = "patchelf";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
